onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+dcm_24MHz -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dcm_24MHz xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {dcm_24MHz.udo}

run -all

endsim

quit -force
