class wr_mon;
	
	trans wr_mon_data,copy_wr_mon2rm;
	mailbox #(trans) wr_mon2rm;
	virtual counter_if.WR_MON_MP wr_mon_if;

	function new(
		virtual counter_if.WR_MON_MP wr_mon_if,
		mailbox #(trans) wr_mon2rm);
	
		this.wr_mon_if = wr_mon_if;
		this.wr_mon2rm = wr_mon2rm;
		wr_mon_data = new;
	endfunction
	
	task monitor();
		//repeat(2) 
		@(wr_mon_if.wr_mon_cb);
		wr_mon_data.reset_n = wr_mon_if.wr_mon_cb.reset_n;
		wr_mon_data.load = wr_mon_if.wr_mon_cb.load;
		wr_mon_data.up_down = wr_mon_if.wr_mon_cb.up_down;
		wr_mon_data.data_in = wr_mon_if.wr_mon_cb.data_in;
		wr_mon_data.display2("From Write Monitor");
		//@(wr_mon_if.wr_mon_cb);
	endtask

	task start();
		fork 
			forever begin
				monitor();
				copy_wr_mon2rm = new wr_mon_data;
				wr_mon2rm.put(copy_wr_mon2rm);
			end
		join_none
	endtask
	
endclass : wr_mon