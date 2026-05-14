module top;
	
	import counter_pkg::*;

	parameter CYCLE = 10;
	bit clk;

	//int no_of_transactions = 20;	

	initial begin
	clk  = 1'b0;
	forever #(CYCLE/2) clk = ~clk;
	end

	counter_if duv_if(clk);
	
	mod_12_up_down_counter DUV(.clock(clk),
				  .reset_n(duv_if.reset_n),
				  .load(duv_if.load),
				  .up_down(duv_if.up_down),
				  .data_in(duv_if.data_in),
				  .count(duv_if.count));

	test test_h;
	
	initial begin
	test_h = new(duv_if,duv_if,duv_if);
	test_h.build();
	test_h.run();
	$finish;
	end
endmodule : top