onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+dcm_12MHz -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dcm_12MHz xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {dcm_12MHz.udo}

run -all

endsim

quit -force
