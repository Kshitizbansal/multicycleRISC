module mux2_to_1(input_a,input_b,sel,result);

input [15:0] input_a;
input [15:0] input_b;
input sel;

output [15:0] result;
reg    [15:0] result;

initial begin
result<=16'h0000;
end


always@(*)
begin
	case(sel)
	0:begin result <= input_a; end
	1:begin result <= input_b; end
	default: begin result <= 16'b0; end
	endcase
end

endmodule



module mux2_to_1_3bit(input_a,input_b,sel,result);

input [2:0] input_a;
input [2:0] input_b;
input sel;

output [2:0] result;
reg    [2:0] result;
initial begin
result<=3'b000;
end
always@(*)
begin
	case(sel)
	0:begin result <= input_a; end
	1:begin result <= input_b; end
	default: begin result <= 3'b0; end
	endcase
end

endmodule

module mux3Bit_4_to_1(input_a,input_b, input_c, input_d, sel,result);

input [2:0] input_a;
input [2:0] input_b;
input [2:0] input_c;
input [2:0] input_d;
input [1:0] sel;

output reg [2:0] result;
initial begin
result<=3'b000;
end
always@(*)
begin
	case(sel)
	2'b00:begin result <= input_a; end
	2'b01:begin result <= input_b; end
	2'b10:begin result <= input_c; end
	2'b11:begin result <= input_d; end
	default: begin result <= 3'b0; end
	endcase
end

endmodule

//module mux3_to_1(input_a,input_b, input_c, sel,result);
//
//input [15:0] input_a;
//input [15:0] input_b;
//input [15:0] input_c;
//input [1:0]sel;
//
//output [15:0] result;
//reg    [15:0] result;
//
//always@(*)
//begin
//	case(sel)
//	2'b00:begin result <= input_a; end
//	2'b01:begin result <= input_b; end
//	2'b10:begin result <= input_c; end
//	default: begin result <= 16'b0; end
//	endcase
//end
//endmodule

module mux4_to_1(input_a,input_b, input_c, input_d, sel,result);

input [15:0] input_a;
input [15:0] input_b;
input [15:0] input_c;
input [15:0] input_d;
input [1:0]sel;

output [15:0] result;
reg    [15:0] result;
initial begin
result<=16'h0000;
end
always@(*)
begin
	case(sel)
	2'b00:begin result <= input_a; end
	2'b01:begin result <= input_b; end
	2'b10:begin result <= input_c; end
	2'b11:begin result <= input_d; end
	default: begin result <= 16'b0; end
	endcase
end

endmodule
	
