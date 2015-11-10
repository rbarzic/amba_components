source vivado_utils.tcl


read_verilog "../rtl/verilog/ahb_to_ssram.v"
read_verilog "../sim/sync_ram_wf.v"
read_verilog "../sim/chip.v"


set include_dir ""
set include_dir [concat $include_dir "../../common/include"]
read_xdc ./xilinx_constraints.xdc

synth_design -include_dirs $include_dir -verilog_define SYNTHESYS -top chip

set outputDir ./rpt
file mkdir $outputDir

report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization -file $outputDir/post_synth_util.rpt


exit


#read_verilog "$top_ds/logical/cmsdk_ahb_to_apb/verilog/cmsdk_ahb_to_apb.v"
#
#
#read_verilog "$top_ds/logical/models/memories/cmsdk_ahb_memory_models_defs.v"
#
#read_verilog "$top_ds/logical/models/memories/cmsdk_ahb_ram_beh.v"
#read_verilog "$top_ds/logical/models/memories/cmsdk_ahb_rom.v"
#read_verilog "$top_ds/logical/models/clkgate/cmsdk_clock_gate.v"
#read_verilog "$top_ds/logical/cmsdk_ahb_gpio/verilog/cmsdk_ahb_to_iop.v"
#
#
#
#

#read_verilog "$top_ds/systems/cortex_m0_mcu/verilog/tb_cmsdk_mcu.v"
#read_verilog "$top_ds/systems/cortex_m0_mcu/verilog/cmsdk_uart_capture.v"

#
#read_verilog "$top_ds/systems/cortex_m0_mcu/verilog/cmsdk_clkreset.v"
#read_verilog "$top_ds/systems/cortex_m0_mcu/verilog/cmsdk_mcu.v"
#read_verilog "$top_ds/systems/cortex_m0_mcu/verilog/cmsdk_mcu_defs.v"
#
#
#
#
