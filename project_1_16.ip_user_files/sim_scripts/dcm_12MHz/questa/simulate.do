onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dcm_12MHz_opt

do {wave.do}

view wave
view structure
view signals

do {dcm_12MHz.udo}

run -all

quit -force
