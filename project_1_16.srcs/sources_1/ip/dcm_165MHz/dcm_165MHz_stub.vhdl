-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Sun Dec 31 21:58:48 2023
-- Host        : DESKTOP-3CM1VFK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/Vivado_Projects/I2c/project_7/project_7.srcs/sources_1/ip/dcm_165MHz/dcm_165MHz_stub.vhdl
-- Design      : dcm_165MHz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dcm_165MHz is
  Port ( 
    clk_sdram : out STD_LOGIC;
    reset : in STD_LOGIC;
    LOCKED : out STD_LOGIC;
    clk : in STD_LOGIC
  );

end dcm_165MHz;

architecture stub of dcm_165MHz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_sdram,reset,LOCKED,clk";
begin
end;
