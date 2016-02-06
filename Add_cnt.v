module Add_cnt(clk, enbl, C_add);

input clk, enbl;
output reg[2:0] C_add;

initial begin
	C_add=3'b000;
end

always @ (posedge clk) begin
		if(enbl) begin
			C_add<=C_add + 3'b001;
			end
		else begin
			C_add<=C_add;
		end
end

endmodule