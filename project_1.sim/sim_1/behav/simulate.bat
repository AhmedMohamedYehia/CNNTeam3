@echo off
set xv_path=C:\\Vivado\\2015.2\\bin
call %xv_path%/xsim FPMU1_tb_behav -key {Behavioral:sim_1:Functional:FPMU1_tb} -tclbatch FPMU1_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
