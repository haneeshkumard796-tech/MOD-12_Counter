module mod_12_up_down_counter(clock,reset_n,load,up_down,data_in,count);
	input clock,reset_n,load,up_down;
	input [3:0]data_in;
	output reg [3:0]count;
	
always@(posedge clock) begin
	if(!reset_n)
		count <= 4'd0;
	else
		if(load)
			count <= data_in;
		else
			if(up_down)
				if(count >= 4'd11)
					count <= 4'd0;
				else
					count <= count + 4'd1;
			else begin
				if((count == 4'd0) || (count > 4'd11)) begin
					count <= 4'd11;
/*					case(count)
						4'd0 : count <= 4'd11;
						4'd12,4'd13,4'd14,4'd15 : count <= 4'd0;
					endcase
*/				end
				else
					count <= count - 4'd1;
		end		

	end
endmodule