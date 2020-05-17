@echo off
set xv_path=D:\\VIVADOSETUP\\Vivado\\2015.2\\bin
call %xv_path%/xsim Conv_Basic_tb_behav -key {Behavioral:sim_1:Functional:Conv_Basic_tb} -tclbatch Conv_Basic_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
