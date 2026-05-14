class sb;	
	
	event done;
	bit b;

	//trans fifo[$];
	
	int data_verified,succ_verified,usucc_verified;
	
	trans refmdata, rdmondata;
	
	mailbox #(trans) refm2sb;
	mailbox #(trans) rdmon2sb;
	
	function new(mailbox #(trans) refm2sb, rdmon2sb);
		this.refm2sb = refm2sb;
		this.rdmon2sb = rdmon2sb;
		refmdata = new;
		rdmondata = new;
	endfunction
	
	task compare();
		//$display("\n\n %p \n\n ",fifo.pop_back());
		if(b) begin
		if(refmdata.count !== rdmondata.count) begin
			$display("Data Mismatch");
			usucc_verified = usucc_verified + 1;
		end
		else begin
			$display("Data Matched");
			succ_verified = succ_verified + 1;
		end	
			data_verified = data_verified + 1;
		end
		b = 1'b1;

		endtask	:compare

	task start();
		fork
			forever begin
				refm2sb.get(refmdata);
				//fifo.push_front(refmdata);
				//if(b == 1'b0) refm2sb.get(refmdata);
				//$display("Reference model data: %0d",refmdata.count);
				rdmon2sb.get(rdmondata);
				//$display("Read monitor data: %0d",rdmondata.count);
				if(b == 1'b0) rdmon2sb.get(rdmondata);
				//rdmon2sb.get(rdmondata);	
				compare();	
				if(data_verified >= no_of_transactions)
					->done;
			end
		join_none
	endtask	:start
	
	task report();
		$display("-----------------------Report---------------------");
		$display("Total no of transaction : %0d",no_of_transactions);
		$display("No of transactions Verified : %0d",data_verified);
		$display("No of transactions succesfully verified : %0d", succ_verified);
		$display("No of transactions unsuccesful : %0d",usucc_verified);
		//$finish;
	endtask : report
endclass :sb