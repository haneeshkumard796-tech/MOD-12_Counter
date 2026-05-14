interface counter_if(input bit clock);

	logic reset_n,load,up_down;
	logic [3:0]data_in,count;
	
	clocking wr_drv_cb @(posedge clock);
		default input #1 output #1;
		
		output reset_n, load, up_down;
		output data_in;
	endclocking
	
	clocking wr_mon_cb @(posedge clock);
		default input #1 output #1;

		input reset_n, load, up_down;
		input data_in;

	endclocking 

	clocking rd_mon_cb @(posedge clock);
		default input negedge output #1;

		input count;	
	endclocking


	modport WR_DRV_MP(clocking wr_drv_cb);
	
	modport WR_MON_MP(clocking wr_mon_cb);
	
	modport RD_MON_MP(clocking rd_mon_cb);
endinterface