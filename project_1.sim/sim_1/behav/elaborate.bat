@echo off
set xv_path=F:\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto b1616306e2754361881eaf2e8e4c5115 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot Conv_Basic_tb_behav xil_defaultlib.Conv_Basic_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
