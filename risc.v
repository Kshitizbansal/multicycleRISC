module risc(clk_50,reset,clk,rg0, rg1, rg2, rg3, rg4, rg5, rg6, rg7);
input clk, reset, clk_50;
wire reset, clk,   ccr_update,aluSrca, regA_in, RegWrite, IrWrite, zero, overflow, mem_write, mem_read, enbl;
wire [1:0] aluSrcb,  R_pc, RegDst, Aluop,b_c, MemtoReg, IorD, flagreg;
wire [2:0] count;
wire out_en;
output [15:0] rg0, rg1, rg2, rg3, rg4, rg5, rg6, rg7;
//output [15:0] st2, o3, alu, irO, memDataOut;            st2,o3, alu, irO, memDataOut
wire [15:0] memAddr, memWrData, memDataOut, instr;
wire [15:0]st1,o2,o4, irOutt;
/*assign st2=st1;
assign o3=o2;
assign alu=o4;
assign irO=irOutt;*/

Datapath dp (reset, clk, memAddr, memWrData, R_pc, ccr_update,
 memDataOut, aluSrca, aluSrcb, RegDst, RegWrite, b_c,
 MemtoReg, IorD, IrWrite, Aluop, instr, zero, overflow, flagreg,o4,o2,irOutt,enbl,count, out_en,regA_in,  rg0, rg1, rg2, rg3, rg4, rg5, rg6, rg7);
 


memory mem(clk, memAddr, memWrData, memDataOut, mem_write, mem_read);

controller con(reset, clk, mem_read, mem_write,  R_pc,
				aluSrca, aluSrcb, RegDst, RegWrite, b_c, MemtoReg,
				IorD, IrWrite, Aluop, instr, flagreg,st1, ccr_update,enbl,count, out_en,regA_in);
				
endmodule

