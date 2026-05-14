package counter_pkg;

	int no_of_transactions = 10;

	`include "trans.sv"
	`include "gen.sv"
	`include "wr_drv.sv"
	`include "wr_mon.sv"
	`include "rd_mon.sv"
	`include "refm.sv"
	`include "sb.sv"
	`include "env.sv"
	`include "test.sv"

endpackage