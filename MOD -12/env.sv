class env;
	virtual counter_if.WR_DRV_MP wr_drv_if;
	virtual counter_if.WR_MON_MP wr_mon_if;
	virtual counter_if.RD_MON_MP rd_mon_if;
	
	mailbox #(trans) gen2wr = new;
	mailbox #(trans) wr_mon2rm = new;
	mailbox #(trans) rm2sb = new;
	mailbox #(trans) rd_mon2sb = new;

	gen gen_h;
	wr_drv wr_drv_h;
	wr_mon wr_mon_h;
	rd_mon rd_mon_h;
	refm   refm_h;	
	sb     sb_h;

	function new(
			virtual counter_if.WR_DRV_MP wr_drv_if,
			virtual counter_if.WR_MON_MP wr_mon_if,
			virtual counter_if.RD_MON_MP rd_mon_if );
	
	this.wr_drv_if = wr_drv_if;
	this.wr_mon_if = wr_mon_if;
	this.rd_mon_if = rd_mon_if;

	endfunction
	
	task  build;
		gen_h = new(gen2wr);
		wr_drv_h = new(wr_drv_if,gen2wr);
		wr_mon_h = new(wr_mon_if,wr_mon2rm);
		rd_mon_h = new(rd_mon_if,rd_mon2sb);
		refm_h = new(wr_mon2rm,rm2sb);
		sb_h = new(rm2sb,rd_mon2sb);
	endtask : build

	task start();
		gen_h.start();
		wr_drv_h.start();
		wr_mon_h.start();
		rd_mon_h.start();
		refm_h.start();
		sb_h.start();
	endtask	:start
	
	task reset_dut();		
	@wr_drv_if.wr_drv_cb;
	wr_drv_if.wr_drv_cb.reset_n <= 1'b0;
	//@wr_drv_if.wr_drv_cb;
	endtask

	task stop();
		wait(sb_h.done.triggered);
	endtask: stop

	task run();
		reset_dut();
		start;
		stop;
		sb_h.report;
	
	endtask
endclass : env