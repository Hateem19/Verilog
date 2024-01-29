`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 09:42:57 PM
// Design Name: 
// Module Name: filter
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

module Generic_Filter #(
    parameter KERNEL_SIZE = 3, // Size of the square kernel by default
    parameter INPUT_SIZE = 4
) (
    input clk,
    input reset,
    input reg [INPUT_SIZE-1:0] pixel_window[0:KERNEL_SIZE * KERNEL_SIZE - 1], // 1D array for pixel window
    input integer KERNEL_VALUES[0:KERNEL_SIZE * KERNEL_SIZE - 1],
    output reg [INPUT_SIZE:0] pixel_out,
    input integer NORMALIZE
);

initial begin
        pixel_window[0] = 0;
        pixel_window[1] = 0;
        pixel_window[2] = 0;
        pixel_window[3] = 0;
        pixel_window[4] = 0;
        pixel_window[5] = 0;
        pixel_window[6] = 0;
        pixel_window[7] = 0;
    end

integer i;
integer sum, kernel_sum;

always @(posedge clk) begin
    if (reset) begin
        pixel_out <= 0;
    end else begin
        sum = 0;
        kernel_sum = 0;

        // Calculate the filtered pixel
        for (i = 0; i < KERNEL_SIZE * KERNEL_SIZE; i = i + 1) begin
            sum = sum + (pixel_window[i] * KERNEL_VALUES[i]);
        end
        // Check whether to normalize the pixel or not
        if (NORMALIZE == 1) begin
            for (i = 0; i < KERNEL_SIZE * KERNEL_SIZE; i = i + 1) begin
                kernel_sum = kernel_sum + KERNEL_VALUES[i];
            end
            // Normalized pixel
            pixel_out <= sum / kernel_sum;
        end else begin
            // Non Normalized pixel
            pixel_out <= sum;
        end
    end
end

endmodule


