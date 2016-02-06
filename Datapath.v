module Datapath(reset, clk, memAddr, memWrData, R_pc, ccr_update,
 memDataOut, aluSrca, aluScrb, RegDst, RegWrite, B_C,
 MemtoReg, IorD, IrWrite, Aluop, instr, zero, overflow, flagreg,aluout,aluRegOut, irOut,enbl,C_add, out_en,regA_in, rg0, rg1, rg2, rg3, rg4, rg5, rg6, rg7);

input reset, clk,  ccr_update,enbl;
input wire [15:0] memDataOut;
output wire [15:0] memAddr, memWrData;
input aluSrca, RegWrite, regA_in,   IrWrite;// PcWriteControl;
input [1:0] Aluop,R_pc,  B_C,aluScrb, RegDst, MemtoReg,IorD;
output [15:0] instr,aluRegOut,aluout; output zero, overflow; output [1:0] flagreg; 
//______________________-------------------------______________________\\ register mein clk kyo di h ?!!
output [15:0]irOut;
wire [15:0] aluRegOut, irOut,mux_b_A_out, mux_after_mdr_Out, regFileOutA, regFileOutB, regAout, regBout, small_mux_before_alu_out, big_mux_before_alu_out;
wire [2:0] mux_after_ir_out, Pc_sel, mux4B_C_out;
//0000000000000000000

output [15:0]  rg0, rg1, rg2, rg3, rg4, rg5, rg6, rg7;
//000000000000
wire [2:0]regCkBits= irOut[11:9];
output wire [2:0]C_add;
output wire out_en;
wire [15:0] count_addr;
assign count_addr[15:3]=13'b0000000000000;
assign count_addr[2:0]=C_add;
wire [2:0]regAkBits= irOut[8:6];           // dekhlena bhai assign krke likhna h k ni
wire [2:0]regBkBits= irOut[5:3];
wire [15:0]ir2signextend_kbaad= (irOut[5]==0)?(irOut & 16'h003F):(irOut | 16'hFFC0);
wire [15:0]jtype_signextend_kbaad= (irOut[8]==0)?(irOut & 16'h01FF):(irOut | 16'hFE00);
wire [15:0] aluout;// mdrOut1;// pcin;
wire [15:0]instr=irOut;
wire [7:0]inst=irOut[7:0];
wire [1:0]flags;
assign flags[0]= zero;
assign flags[1]= overflow;
assign memWrData= regFileOutB;


//regsel pc(clk, PcWriteControl, pcin, pcOut );

mux4_to_1 mux_after_pc(regFileOutA,regAout,16'h0000, aluout, IorD, memAddr);//changed

mux2_to_1 mux_bef_RegA(regFileOutA, aluout, regA_in,mux_b_A_out );
//mem memory(clk, memAddr, memWrData, memDataOut, opcode); <<<<<<<<<<   no need !!!!

regsel ir( clk, IrWrite, memDataOut, irOut);

mux3Bit_4_to_1 mux4PcSelect(regAkBits,regBkBits,regCkBits, 3'b111, R_pc, Pc_sel);

mux3Bit_4_to_1 mux_after_ir(regBkBits, regCkBits, 3'b111, C_add, RegDst, mux_after_ir_out);

//register mdr(clk, memDataOut, mdrOut1);

mux3Bit_4_to_1 mux4B_C(regBkBits,regAkBits, C_add, regCkBits, B_C, mux4B_C_out);

mux4_to_1 mux_after_mdr(memDataOut, aluRegOut,aluout, jtype_signextend_kbaad, MemtoReg , mux_after_mdr_Out); // J type sign extended left

regfile regFile(clk, Pc_sel, regFileOutA, regFileOutB, mux4B_C_out, RegWrite, mux_after_ir_out, mux_after_mdr_Out, rg0, rg1, rg2, rg3, rg4, rg5, rg6, rg7);

register regA(clk, mux_b_A_out, regAout);

register regB(clk, regFileOutB, regBout);

mux2_to_1 small_mux_before_alu(regAout, regFileOutA, aluSrca, small_mux_before_alu_out);

mux4_to_1 big_mux_before_alu(regFileOutB, ir2signextend_kbaad, count_addr, 16'h0001, aluScrb, big_mux_before_alu_out);     //16'h0000  shift left 2 wala, are jo neeche h!!

alu alu1(small_mux_before_alu_out, big_mux_before_alu_out, Aluop, overflow, zero, aluout);

regsel2bit flagregs(clk, ccr_update, flags, flagreg );
//register2bit flagregs(clk,  flags, flagreg );

register aluOutReg(clk, aluout, aluRegOut);

Encoder encoder(enbl, inst, C_add, out_en, clk);

//mux2_to_1 mux_after_alu(aluRegOut, aluout, pcin);

endmodule



