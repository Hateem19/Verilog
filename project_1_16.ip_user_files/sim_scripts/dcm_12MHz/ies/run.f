-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xilinx_18/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Xilinx_18/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx_18/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../project_7.srcs/sources_1/ip/dcm_12MHz/dcm_12MHz_clk_wiz.v" \
  "../../../../project_7.srcs/sources_1/ip/dcm_12MHz/dcm_12MHz.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

