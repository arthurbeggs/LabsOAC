## Generated SDC file "TopDE.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Sat Jun 20 00:28:03 2015"

##
## DEVICE  "EP2C70F896C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {iCLK_50 iCLK_50_4}]
create_clock -name {clock28} -period 35.714 -waveform { 0.000 17.857 } [get_ports {iCLK_28}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {CLOCK_Interface:CLKI0|PLL:PLL1|altpll:altpll_component|_clk0} -source [get_pins {CLKI0|PLL1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {clock} [get_pins {CLKI0|PLL1|altpll_component|pll|clk[0]}] 
create_generated_clock -name {CLOCK_Interface:CLKI0|PLL:PLL1|altpll:altpll_component|_clk2} -source [get_pins {CLKI0|PLL1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 4 -master_clock {clock} [get_pins {CLKI0|PLL1|altpll_component|pll|clk[2]}] 
create_generated_clock -name {AudioCODEC_Interface:Audio0|VGA_Audio_PLL:p1|altpll:altpll_component|_clk1} -source [get_pins {Audio0|p1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -divide_by 3 -master_clock {clock28} [get_pins {Audio0|p1|altpll_component|pll|clk[1]}] 
create_generated_clock -name {VGA_Interface:VGA0|VgaAdapter:VGA0|VgaPll:xx|altpll:altpll_component|_clk0} -source [get_pins {VGA0|VGA0|xx|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2 -master_clock {clock} [get_pins {VGA0|VGA0|xx|altpll_component|pll|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {clock}]  -to  [get_clocks {clock28}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

