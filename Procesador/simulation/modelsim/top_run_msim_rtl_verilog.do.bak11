transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/ramvectorial.v}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/arr2bits.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/controllerV.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/RegV.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/adder.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/top.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/processor.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/controller.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/conditional.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/datapath.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/hazard.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/regfile.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/extend.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/alu.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/flopr.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/flopenrc.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/floprc.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/mux2.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/mux3.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/eqcmp.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/alu_vect_2.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/instvecorscalar.sv}
vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/imem.sv}

vlog -sv -work work +incdir+C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador {C:/Users/Jonathan/Desktop/AudioSIMD-FIR-1/Procesador/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
