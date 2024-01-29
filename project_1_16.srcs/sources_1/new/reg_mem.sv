`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2024 05:28:50 PM
// Design Name: 
// Module Name: reg_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_mem_reg (
    input wire clk,             // Clock signal
    input wire [15:0] pixel_in, // 16-bit input for pixel value
    output reg [15:0] pixel_out[8:0], // 16-bit array of size 9 for output
    output reg array_filled,     // Flag to indicate if the array is filled
    output reg pixel_o
);

    integer i;
    reg [3:0] count = 0; // Counter to track the number of pixels stored
    initial begin
        pixel_out[0] = 0;
        pixel_out[1] = 0;
        pixel_out[2] = 0;
        pixel_out[3] = 0;
        pixel_out[4] = 0;
        pixel_out[5] = 0;
        pixel_out[6] = 0;
        pixel_out[7] = 0;
        pixel_out[8] = 0;
        count = 0;
    end
    assign pixel_o = pixel_out[8];
    // Sequential logic for shifting operation
    always @(posedge clk) begin
        if (count < 9) begin
            // Fill the array without shifting
            pixel_out[count] = pixel_in;
            count = count + 1;
            if (count == 9) array_filled = 1; // Set flag when array is full
        end else begin
            // Shift operation
            for (i = 1; i < 9; i = i + 1) begin
                pixel_out[i] <= pixel_out[i - 1];
            end
            pixel_out[0] <= pixel_in; // Insert new pixel value at the beginning
        end
    end

endmodule
