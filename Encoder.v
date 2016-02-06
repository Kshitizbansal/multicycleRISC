module Encoder (enbl, inst, dout, out_en, clk);
input enbl, clk;
input [7:0] inst;
output reg [2:0] dout; 
reg [7:0] din;
output reg out_en;

initial begin
dout=3'b000;
din=8'b00000000;
end

always @ (posedge clk) begin
if (enbl==1'b1) begin din<=inst; end
	else din[dout]<=1'b0;

end

always @(*) begin
	 if (din[0]==1'b1) begin  dout<=3'b000;  out_en<=1'b1; end
else if (din[1]==1'b1) begin  dout<=3'b001;  out_en<=1'b1; end
else if (din[2]==1'b1) begin  dout<=3'b010;  out_en<=1'b1; end
else if (din[3]==1'b1) begin  dout<=3'b011;  out_en<=1'b1; end
else if (din[4]==1'b1) begin  dout<=3'b100;  out_en<=1'b1; end
else if (din[5]==1'b1) begin  dout<=3'b101;   out_en<=1'b1;end
else if (din[6]==1'b1) begin  dout<=3'b110;  out_en<=1'b1; end
else if (din[7]==1'b1) begin  dout<=3'b111;  out_en<=1'b1; end
else begin dout<=3'b000; out_en<=1'b0; end
		
end

endmodule 
