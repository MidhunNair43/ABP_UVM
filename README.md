# APB_UVM
Advanced Peripheral Bus
A APB module with a simple UVM testbench. The module takes in the address (paddr) and a 32 bit data to be written (pwdata). 
write variable takes in 00- NOP 01- Read 11- Write.
A randomly generated data is generated to pwdata and the address is fixed for testing purposes as randomly generated address may not repeat again
and hence cannot cross check the value. 
