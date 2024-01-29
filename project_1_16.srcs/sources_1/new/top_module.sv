`timescale 1ns / 1ps

module top_module(
    input wire clk,rst, // @@ rst_n is not as expected

	input wire[3:0] key, //key[1:0] for brightness control , key[3:2] for contrast control
	
	// camera pinouts
	input wire cmos_pclk,cmos_href,cmos_vsync,
	input wire[7:0] cmos_db,
	
	input wire [15:0] SW,
	
	inout cmos_sda,cmos_scl, 
	output wire cmos_rst_n, cmos_pwdn, cmos_xclk,
	
	// Debugging
	output [3:0] led, 
	
	// @@ VGA output
	output wire[3:0] vga_out_r4,
	output wire[3:0] vga_out_g4,
	output wire[3:0] vga_out_b4,
	output wire vga_out_vs,vga_out_hs
);

	wire f2s_data_valid;
	wire[9:0] data_count_r;
	wire[15:0] dout,din;
	wire clk_sdram;
	wire empty_fifo;
	wire clk_vga;
	wire state;
	wire rd_en;

	wire clk_50MHz;
	wire clk_25MHz;
    wire clk_24MHz, clk_22;
	wire [3:0] vga_out_r;
	wire [3:0] vga_out_g;
	wire [3:0] vga_out_b;

    wire rst_n;
    assign rst_n = ~rst;

    clock_divisor clk_wiz_0_inst(
      .clk(clk),//clk_100
	  .clk0(clk_50MHz),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );
    
    wire wr_en;
    wire [15:0] pixel_q;
    wire vsync_1, vsync_2;
    camera_interface m0 
	(
		.clk(clk_50MHz), 
        .clk_100(clk),
		.rst_n(rst_n),
		.key(key),
		//asyn_fifo IO
		.rd_en(f2s_data_valid),
		.data_count_r(data_count_r),
		.dout(dout),
		//camera pinouts
		.cmos_pclk(cmos_pclk),
		.cmos_href(cmos_href),
		.cmos_vsync(cmos_vsync),
		.cmos_db(cmos_db),
		.cmos_sda(cmos_sda),
		.cmos_scl(cmos_scl), 
		.cmos_rst_n(cmos_rst_n),
		.cmos_pwdn(cmos_pwdn),
		.cmos_xclk(cmos_xclk),
		//Debugging
		.led(led),
        .wr_en(wr_en),
        .pixel_q(pixel_q),
        .vsync_1(vsync_1),
        .vsync_2(vsync_2)
	);

    wire [16:0] pixel_addr;
    wire [9:0]h_cnt;
    wire [9:0]v_cnt;
    wire valid; 

    // ! @@ generate write pixel address
    wire [16:0] pixel_addr_wr;
    reg [18:0] pixel_addr_wr_counter, pixel_addr_wr_counter_next;

    always @(posedge wr_en or posedge rst or posedge vsync_1) begin
        if(rst || vsync_1) begin
            pixel_addr_wr_counter = 19'b0;
        end
        else begin
            pixel_addr_wr_counter = pixel_addr_wr_counter_next;
        end
    end
    wire LOCKED1;
    wire clk_12MHz;
    reg [15:0] pixel_out[8:0];
    reg array_filled;
    reg [15:0] pixel_q1, pixel_q2;
    integer kernel [0:8];
    integer norm;
    initial begin
        kernel = {0,0,0,0,1,0,0,0,0};
        norm = 0;
    end
    
    always @ (posedge clk)
    begin
        case(SW)
            16'b0000000000000001 : begin kernel <= {0,-1,0,-1,4,-1,0,-1,0}; norm <= 0; end
            16'b0000000000000010 : begin kernel <= {-1,-1,-1,-1,8,-1,-1,-1,-1}; norm <= 0; end //outline
            16'b0000000000000100 : begin kernel <= {0,-1,0,-1,5,-1,0,-1,0}; norm <= 0; end // Sharpen
            16'b0000000000001000 : begin kernel <= {-1,-2,-1,0,0,0,1,2,1}; norm <= 0; end // Sobol Detections
            16'b0000000000010000 : begin kernel <= {-1,-2,0,-1,1,1,0,1,2}; norm <= 0; end // Emboss
            16'b0000000000100000 : begin kernel <= {-1,-2,-1,-1,-2,-1,-1,-2,-1}; norm <= 0; end // Vertical detection
            16'b0000000001000000 : begin kernel <= {-1,-1,-1,2,2,2,-1,-1,-1}; norm <= 0; end // Horizontal detection
            16'b0000000010000000 : begin kernel <= {1,0,0,0,1,0,0,0,0}; norm <= 0; end // warm filter
            16'b0000000100000000 : begin kernel <= {-1,0,0,0,2,0,0,0,0}; norm <= 0; end // Increase Green and Decrease Red
            16'b0000001000000000 : begin kernel <= {2,0,0,0,2,0,0,0,0}; norm <= 0; end // Emphasize Red and Green Channels
            16'b0000010000000000 : begin kernel <= {0,0,0,0,2,0,0,0,0}; norm <= 0; end // Increase Red
            16'b0000100000000000 : begin kernel <= {1,0,0,1,0,0,1,0,0}; norm <= 1; end // Vertical Motion Blur
            16'b0001000000000000 : begin kernel <= {1,1,1,0,0,0,0,0,0}; norm <= 1; end // Horizontal Motion Blur
            16'b0010000000000000 : begin kernel <= {1,2,1,2,4,2,1,2,1}; norm <= 1; end // Slight Gaussian Blur
            16'b0100000000000000 : begin kernel <= {1,1,1,1,1,1,1,1,1};  norm <= 0; end // Box Blur (or Average Blur)
            16'b1000000000000000 : begin kernel <= {1,1,1,1,1,1,1,1,1}; norm <= 1; end // Box Blur (or Average Blur)
            default : begin kernel <= {0,0,0,0,1,0,0,0,0}; norm <= 0; end
        endcase
    end
    
    dcm_12MHz m1
           (
            // Clock in ports
            .clk_in1(clk_50MHz),      // IN
            // Clock out ports
            .clk_out1(clk_12MHz),     // OUT
            // Status and control signals
            .reset(rst),// IN
            .locked(LOCKED1) // OUT
        );
        shift_mem_reg reg1(
            .clk(clk_24MHz),             // Clock signal
            .pixel_in(pixel_q), // 16-bit input for pixel value
            .pixel_out(pixel_out), // 16-bit array of size 9 for output
            .array_filled(array_filled),     // Flag to indicate if the array is filled
            .pixel_o(pixel_q2)
        );
        Generic_Filter #(.INPUT_SIZE(16)) dut11 (
            .clk(clk_24MHz),
            .reset(0),
            .pixel_window(pixel_out), // 1D array for pixel window
            .KERNEL_VALUES(kernel),
            .pixel_out(pixel_q1),
            .NORMALIZE(norm)
        );
    
    // localparam WIDTH=660, HEIGHT=490;
    // @@ small horizontal shift and vertical shift
    localparam WIDTH=640, HEIGHT=480;
    // localparam WIDTH=320, HEIGHT=240;

    // count in the resolution of 640x480
    always @(*) begin
        if (pixel_addr_wr_counter == (WIDTH*HEIGHT)-1) begin
            pixel_addr_wr_counter_next = 19'b0;
        end
        else begin
            pixel_addr_wr_counter_next = pixel_addr_wr_counter + 1'b1;
        end
    end
    // from 640x480 to 320x240
    assign pixel_addr_wr =  
        (320*(pixel_addr_wr_counter/WIDTH/2) + (pixel_addr_wr_counter%WIDTH/2)) % 76800;

    // 320x240, combinational logic
    mem_addr_gen mem_addr_gen_inst
    (
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .pixel_addr(pixel_addr)
    );
    vga_controller ctrl
    (
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(vga_out_hs),
        .vsync(vga_out_vs),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );

    wire [3:0] vgaRed;
    wire [3:0] vgaGreen;
    wire [3:0] vgaBlue;
    assign {vga_out_r4, vga_out_g4, vga_out_b4} = (valid==1'b1) ? {vgaRed, vgaGreen, vgaBlue} : 12'h0;
    
    // simple dual port
    blk_mem_gen_0 blk_mem_gen_0_inst 
    (
        // read
        .clkb(clk_25MHz),
        // .web(1'b0),
        .addrb(pixel_addr),
        .doutb( {vgaRed, vgaGreen, vgaBlue}),
        // .clka(clk_sdram),
        .clka(clk),
        // ! @@ write
        .wea(wr_en 
            // && ((pixel_addr_wr_counter%WIDTH/2) < 320) 
            // && ((pixel_addr_wr_counter/WIDTH/2) < 240)
        ),

        .addra(pixel_addr_wr),
        //RGB
        .dina({pixel_q1[15:12], pixel_q1[10:7], pixel_q1[4:1]})
    ); 

    wire LOCKED;
    dcm_165MHz m3
	(
        // Clock in ports
        .clk(clk),      // IN
        // Clock out ports
        .clk_sdram(clk_sdram),     // OUT
        // Status and control signals
        .reset(rst),// IN
        .LOCKED(LOCKED) // OUT
    );
    wire LOCK;
    dcm_24MHz m4
	(
        // Clock in ports
        .clk(clk_50MHz),      // IN
        // Clock out ports
        .cmos_xclk(clk_24MHz),     // OUT
        // Status and control signals
        .reset(rst),// IN
        .LOCKED(LOCK) // OUT
    );
endmodule