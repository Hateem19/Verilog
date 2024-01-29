onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dcm_24MHz_opt

do {wave.do}

view wave
view structure
view signals

do {dcm_24MHz.udo}

run -all

quit -force
