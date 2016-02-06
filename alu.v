module alu(r1, r2, op, carry, zf, out1); 		//arithmetic logic unit
input [15:0] r1, r2;
input[1:0] op;

output carry, zf;
output reg [15:0] out1;
always @(*)
begin
case(op)
2'b00: out1 <= r1+r2;             // 00   addition
2'b01: out1 <= r1-r2;					// 01   subtract
2'b10: out1 <= ~(r1&r2); 			// 10   nand
2'b11: out1 <= 16'h1111;					// 11   or
endcase

end
assign zf = out1 == 16'h0000 ? 1'b1 : 1'b0;
assign carry= ((r1&16'h8000)==(r2&16'h8000)) ? ((r1&16'h8000)==16'h8000 ? 1'b1: 1'b0): ((out1 & 16'h8000)==16'h8000 ? 1'b0: 1'b1);
endmodule