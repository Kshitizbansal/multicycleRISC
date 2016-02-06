module register(clk, in, out);
input [15:0] in;
output reg [15:0] out;
input clk;
always @(posedge clk)begin
out = in;
end
endmodule 

module register2bit(clk, in, out);//    carry__flag
input [1:0] in;
output reg [1:0] out;
input clk;
always @(posedge clk)begin
out = in;
end
endmodule 

module regsel(clk, regwrite, in, out);
input [15:0] in;
output reg [15:0] out;
input clk, regwrite;
always @(posedge clk)begin
out = regwrite == 1'b1 ? in : out;
end
endmodule 


module regsel2bit(clk, regwrite, in, out);
input [1:0] in;
output reg [1:0] out;
input clk, regwrite;
always @(posedge clk)begin
out = regwrite == 1'b1 ? in : out;
end
endmodule 