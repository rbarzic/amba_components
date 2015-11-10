set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { HCLK }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name HCLK  -period 10.00 -waveform {0 5} [get_ports {HCLK}];
