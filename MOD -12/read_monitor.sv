class rd_mon;
	
	trans rd_mon_data,copy_rd_mon2sb;
	mailbox #(trans) rd_mon2sb;
	
	virtual counter_if.RD_MON_MP rd_mon_if;
	
	function new(
		virtual counter_if.RD_MON_MP rd_mon_if,
		mailbox #(trans) rd_mon2sb);
		
		this.rd_mon_if = rd_mon_if;
		this.rd_mon2sb = rd_mon2sb;
		rd_mon_data = new;
	endfunction

	task monitor();
		@(rd_mon_if.rd_mon_cb);
		rd_mon_data.count = rd_mon_if.rd_mon_cb.count;
		rd_mon_data.display2("From Read Monitor");
		//@(rd_mon_if.rd_mon_cb);
	endtask

	task start();
		fork
			forever begin
				monitor();
				copy_rd_mon2sb = new rd_mon_data;
				rd_mon2sb.put(copy_rd_mon2sb);
			end
		join_none
	endtask
endclass : rd_mon