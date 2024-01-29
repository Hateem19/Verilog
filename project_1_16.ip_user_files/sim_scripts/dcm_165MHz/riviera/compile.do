vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"D:/Xilinx_18/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx_18/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx_18/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../project_7.srcs/sources_1/ip/dcm_165MHz/dcm_165MHz_clk_wiz.v" \
"../../../../project_7.srcs/sources_1/ip/dcm_165MHz/dcm_165MHz.v" \

vlog -work xil_defaultlib \
"glbl.v"

