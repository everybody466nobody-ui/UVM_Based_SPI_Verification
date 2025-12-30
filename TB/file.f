// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d
+UVM_TESTNAME=multichannel_test 
+SVSEED=random
+UVM_VERBOSITY=UVM_HIGH
-timescale 1ns/1ns
// include directories
//*** add incdir include directories here

// compile files
//*** add compile files here
//-gui -access rwc

-incdir ../sv 
../sv/spi_pkg.sv 
../sv/wb_if.sv
../sv/spi_slave_if.sv
../sv/simple_spi_top.v
../sv/fifo4.v
tb_top.sv 



