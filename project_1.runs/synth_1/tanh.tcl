# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {Common-41} -limit 4294967295
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg400-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/ziads/Desktop/Junior2/LogicDesign2/Final Assemnet/CNNTeam3/project_1.cache/wt} [current_project]
set_property parent.project_path {C:/Users/ziads/Desktop/Junior2/LogicDesign2/Final Assemnet/CNNTeam3/project_1.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  {C:/Users/ziads/Desktop/Junior2/LogicDesign2/Final Assemnet/CNNTeam3/project_1.srcs/sources_1/new/ADD.v}
  {C:/Users/ziads/Desktop/Junior2/LogicDesign2/Final Assemnet/CNNTeam3/project_1.srcs/sources_1/new/MUL.v}
  {C:/Users/ziads/Desktop/Junior2/LogicDesign2/Final Assemnet/CNNTeam3/project_1.srcs/sources_1/new/tanh.v}
}
synth_design -top tanh -part xc7z020clg400-1
write_checkpoint -noxdef tanh.dcp
catch { report_utilization -file tanh_utilization_synth.rpt -pb tanh_utilization_synth.pb }