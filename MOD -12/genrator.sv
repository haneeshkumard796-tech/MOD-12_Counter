class gen;
		
	trans gen_trans, copy_gen_trans;
	mailbox #(trans) gen2wr;

	function new(mailbox #(trans) gen2wr);
		this.gen2wr = gen2wr;
		gen_trans = new;
	endfunction
	
	task start;
		fork
			for(int i=1;i<=no_of_transactions;i++)
			begin
				assert(gen_trans.randomize());
				gen_trans.display();
				copy_gen_trans = new gen_trans;
				gen2wr.put(copy_gen_trans);
			end
		join_none
	endtask : start
endclass : gen