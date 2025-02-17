transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/ram.v}
vlog -vlog01compat -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/ramvectorial.v}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/arr2bits.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/controllerV.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/RegV.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/adder.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/top.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/processor.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/controller.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/conditional.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/datapath.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/hazard.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/regfile.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/extend.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/alu.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/flopr.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/flopenrc.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/floprc.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/mux2.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/mux3.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/eqcmp.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/alu_vect_2.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/hazardV.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/bits2arr.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/arr2bits4mem.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/bits2arr4mem.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/instvecorscalar.sv}
vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/imem.sv}

vlog -sv -work work +incdir+C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador {C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
