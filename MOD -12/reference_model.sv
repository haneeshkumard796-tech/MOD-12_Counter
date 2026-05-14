class refm;
	
	trans ref_data, wr_data;	
	
	logic [3:0]count;
	
	mailbox #(trans) rm2sb;
	mailbox #(trans) wr_mon2rm;
	
	function new(
		mailbox #(trans) wr_mon2rm,rm2sb);
		this.rm2sb = rm2sb;
		this.wr_mon2rm = wr_mon2rm;
		//ref_data = new;
		wr_data = new;
	endfunction

	task gen_exp_out();
	
	if(!wr_data.reset_n)
		count = 4'd0;
	else
		if(wr_data.load)
			count = wr_data.data_in;
		else
			if(wr_data.up_down)
				if(count >= 4'd11)
					count = 4'd0;
				else
			
			count = count + 4'd1;
			else
				if((count == 4'd0) || (count > 4'd11))
					count = 4'd11;
/*					case(count)
						4'd0 : count <= 4'd11;
						4'd12,4'd13,4'd14,4'd15 : count <= 4'd0;
					endcase
*/	
				else
					count = count - 4'd1;	
	endtask : gen_exp_out

	task send();
		ref_data = new wr_data;
		ref_data.count = this.count;
		rm2sb.put(ref_data);
	endtask

	task start();
		fork
			forever begin	
				wr_mon2rm.get(wr_data);
				gen_exp_out();
				$display("\n Expected Output : %0d\n",this.count);
				send();
			end
		join_none	
	endtask : start 
endclass : refm