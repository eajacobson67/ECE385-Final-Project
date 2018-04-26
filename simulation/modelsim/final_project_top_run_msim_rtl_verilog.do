transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/vga_clk.v}
vlog -vlog01compat -work work +incdir+D:/ECE_385/final_project/db {D:/ECE_385/final_project/db/vga_clk_altpll1.v}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/lut.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/VGA_controller.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/WriteUpdate.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/ang_lut.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/vector.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/frame_buffer.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/collision_detection.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/color_mapper.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/random.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/final_top_level.sv}
vlog -sv -work work +incdir+D:/ECE_385/final_project {D:/ECE_385/final_project/sphere_reg.sv}

vlog -sv -work work +incdir+D:/ECE_385/final_project/output_files {D:/ECE_385/final_project/output_files/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  random_testbench

add wave *
view structure
view signals
run 30 ms
