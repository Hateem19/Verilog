// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sun Dec 31 21:57:45 2023
// Host        : DESKTOP-3CM1VFK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Vivado_Projects/I2c/project_7/project_7.srcs/sources_1/ip/dcm_24MHz/dcm_24MHz_stub.v
// Design      : dcm_24MHz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module dcm_24MHz(cmos_xclk, reset, LOCKED, clk)
/* synthesis syn_black_box black_box_pad_pin="cmos_xclk,reset,LOCKED,clk" */;
  output cmos_xclk;
  input reset;
  output LOCKED;
  input clk;
endmodule
