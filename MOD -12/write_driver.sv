class wr_drv;

	trans gen_trans;
	mailbox #(trans) gen2wr;

	virtual counter_if.WR_DRV_MP wr_drv_if;
	
	function new(
			virtual counter_if.WR_DRV_MP wr_drv_if,
			 mailbox #(trans)  gen2wr);
		this.wr_drv_if = wr_drv_if;
		this.gen2wr = gen2wr;
		gen_trans = new;
	endfunction

	task drive();
		@wr_drv_if.wr_drv_cb;
		wr_drv_if.wr_drv_cb.reset_n <= gen_trans.reset_n;
		wr_drv_if.wr_drv_cb.load <= gen_trans.load;
		wr_drv_if.wr_drv_cb.up_down <= gen_trans.up_down;
		wr_drv_if.wr_drv_cb.data_in <= gen_trans.data_in;
		gen_trans.display2("From Write Driver");
		//->driven;
		//@(wr_drv_if.wr_drv_cb);
		//repeat(2) @wr_drv_if.wr_drv_cb;
	endtask

	task start();
		fork
			forever begin
				gen2wr.get(gen_trans);
				drive();
				end
		join_none
	endtask
endclass : wr_drv