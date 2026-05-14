class trans;
	
	rand bit reset_n,load,up_down;
	rand bit [3:0]data_in;
	logic [3:0]count;
		
			
	
	static int  trans_id;

	constraint valid_data {data_in inside {[0:11]};}
	//constraint reset_constr {reset_n dist{0:= 1, 1:= 9};}
	constraint reset_constr {reset_n == 1'b1;}
	constraint load_constr {load dist{1:=2, 0:=8};}
	constraint up_down_constr {up_down dist{0:=5, 1:=5};}
	
	function void post_randomize();
		trans_id = trans_id + 1;
	endfunction
	
	function void display();
//		$display({20{"-"}});
		$display("------------------------------------");
		$display("Randomized Data:");
		$display("Transaction ID: %0d", trans_id);		
		$display("Reset : %0d", reset_n);
		$display("load : %0d", load);
		$display("up_down : %0d", up_down);
		$display("data_in : %0d", data_in);
		$display("------------------------------------");
//		$display({20{"-"}});
	endfunction
	
	function void display2(string s);
//		$display({20{"-"}});
		$display("------------------------------------");
		$display(s);
		$display("%0t",$time);
		$display("Reset : %0d", reset_n);
		$display("load : %0d", load);
		$display("up_down : %0d", up_down);
		$display("data_in : %0d", data_in);
		$display("count : %0d", count);
//		$display({20{"-"}});
		$display("------------------------------------");
	endfunction	
endclass : trans