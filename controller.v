module controller(reset, clk, mem_read, mem_write,  R_pc,
						alusrc_a, alusrc_b, regdst, reg_w,b_c, memtoreg,
						i_d, ir_w, alu_op, inst, car_zer, st,ccr_update,enbl,count, out_en,regA_in);
	
input clk, reset;
output reg mem_read, mem_write,  alusrc_a, reg_w,  ir_w, ccr_update,enbl,regA_in;
input [15:0] inst;
input [1:0] car_zer;
input [2:0] count;
input out_en;
output [15:0]st;
//
output reg [1:0] alusrc_b,i_d, alu_op,R_pc,b_c, regdst, memtoreg;

 
reg [15:0]state=16'b0;
reg [15:0]next_state=16'b0;
//wire [3:0]c4bit;
//assign c4bit[3]=1'b0;
//assign c4bit[2:0]=count;
assign st=state;


parameter state_reset 			= 16'b0000000000000000;
parameter read 					= 16'b0000000000000001;
parameter decode 					= 16'b0000000000000010;
parameter adi_execute 			= 16'b0000000000000100;
parameter regw_frm_aluout 		= 16'b0000000000001000;
parameter i_type_load 			= 16'b0000000000010000;
parameter lhi_execute 			= 16'b0000000000100000;
//parameter i_type_regwrite 		= 16'b0000000001000000;
parameter i_type_store 			= 16'b0000000010000000;
parameter branch_compare 		= 16'b0000000100000000;
parameter br_check 				= 16'b0000001000000000;
parameter br_yes 					= 16'b0000010000000000;
parameter jmp_add 				= 16'b0000100000000000;
parameter jmp_store_pc 			= 16'b0001000000000000;
parameter add 						= 16'b0010000000000000;
parameter nanda 					= 16'b0100000000000000;
parameter jlr 						= 16'b1000000000000000;
parameter lw_execute 			= 16'b1000000000000011;
parameter sw_execute 			= 16'b1000000000000101;
parameter LM1 						= 16'b1000000000111100;
parameter LM2			 			= 16'b1000000001111111;
parameter SM1			 			= 16'b1111000001111111;
parameter SM2			 			= 16'b0000100001111110;



always @(posedge clk) begin 
		if(reset==0) begin 
			state <= state_reset; 
		end
        
		  
		else begin 
			state <= next_state;  
		end
end 

always @(*) begin
		if(reset==0) next_state=state_reset;
		else
			case(state)
	 
	 state_reset:  begin 
						next_state=read; 
						end
	 
	 read: 			begin 
						next_state=decode; 
						end
	 
	 decode: 
		begin
			if(inst [15:12] == 4'b0000 ) begin
					if ( inst[1:0] ==2'b00 )next_state = add;	
						
					else if( inst[1:0] ==2'b10 ) begin                     //check if ADC inst
						 
						 if (car_zer == 2'b10 || car_zer == 2'b11)          //carry flag set so add
								next_state = add;
						 else //if (car_zer == 2'b00 || car_zer == 2'b01)     //go to read if carry not set
								next_state = read;
					end
					
					else if( inst[1:0] ==2'b01 ) begin                    //check if ADZ inst
						 
						 if (car_zer==2'b01 || car_zer==2'b11)             //zero flag if set, add
								next_state = add;
						 else //if (car_zer==2'b00 || car_zer==2'b10)        //go to read if zero not set
								next_state = read;
					//else 	next_state <= read; 
					end
					else 
						next_state = read;
			end
//-------------------------------------------------------------------------------------------					
			else if(inst [15:12] == 4'b0010 ) begin
					if ( inst[1:0] ==2'b00 )	next_state = nanda;	
						
					else if( inst[1:0] ==2'b10 ) begin                     //check if NDC inst
						 
						 if (car_zer == 2'b10 || car_zer == 2'b11)          //carry flag set so nand
								next_state = nanda;
						 else //if (car_zer == 2'b00 || car_zer == 2'b01)     //go to read if carry not set
								next_state = read;
						 //else 	next_state <= read;
					end
					
					else if( inst[1:0] ==2'b01 ) begin                    //check if NDZ inst
						 
						 if (car_zer==2'b01 || car_zer==2'b11)             //zero flag if set, nand
								next_state = nanda;
						 else //if (car_zer==2'b00 || car_zer==2'b10)        //go to read if zero not set
								next_state = read;
					end				
					else next_state = read;
			end
//------------------------------------------ADI---------------------------------------------------------
			else if(inst [15:12] == 4'b0001 ) begin
				    next_state=adi_execute;    
			end     //ns is aluout to reg 
															 //ns is setting c and z flags  --nsn
				
					
	 
//------------------------------------------LHI----------------------------------------------------------
         else if(inst [15:12] == 4'b0011 ) begin
					   next_state= lhi_execute;   
			end                        //load msb of imm data to Ra  --nsn
																			
//------------------------------------------LW----------------------------------------------------------					
	      else if(inst [15:12] == 4'b0100 ) begin
					next_state=lw_execute;      end 						//calculate mem add by adding imm and reg value 
																				//ns will be i_type_load
																	         //ns is i_type_regwrite
//------------------------------------------SW----------------------------------------------------------																			
			else if(inst [15:12] == 4'b0101 ) begin											
					next_state=sw_execute;      end                 //ns is i_type_store
																				
				

////------------------------------------------LM----------------------------------------------------------					
			else if(inst [15:12] == 4'b0110 ) begin
						  next_state= LM1; end                 //nns
//				
////------------------------------------------SM----------------------------------------------------------						
				else if(inst [15:12] == 4'b0111 ) begin
                    next_state=  SM1;  end                //nns
															
//------------------------------------------BEQ----------------------------------------------------------	
			else if(inst [15:12] == 4'b1100 ) begin
               next_state= branch_compare;  end      


						  
//------------------------------------------JAL----------------------------------------------------------
			else if(inst [15:12] == 4'b1000 ) begin
               next_state= jmp_add;    end      //nns
						  
						  
//------------------------------------------JLR----------------------------------------------------------
			else if(inst [15:12] == 4'b1001 ) begin
               next_state= jmp_add;    end      //nns
			
			else next_state= read;
		end

	LM1: begin next_state=LM2; end
		
	LM2: begin if(out_en==1) next_state=LM2; 
					else next_state=read;		end
	
//	LM3: begin if(count==3'b111) next_state=read;	//count++
//					else next_state=LM1;
//			end
	SM1: begin next_state=SM2; end
	
	SM2: begin if(out_en==1) next_state=SM2; 
					else next_state=read;		end		
	
	
	add:		begin next_state=regw_frm_aluout; end
	
	nanda:	begin next_state=read; end
	
	adi_execute:		begin next_state=read; end  
	
	lw_execute:      begin next_state=i_type_load; end
	
	sw_execute:      begin next_state=i_type_store; end
	
	branch_compare: begin next_state=br_check; end
	
	br_check:begin 
					if (car_zer == 2'b01 || car_zer == 2'b11 ) next_state=br_yes;
					else next_state=read;//if (car_zer == 2'b00 || car_zer == 2'b10 ) 
				end
	
	jmp_add: begin if (inst[12]== 1'b0)  next_state=jmp_store_pc;
					else next_state=jlr;//if (car_zer == 2'b00 || car_zer == 2'b10 ) 
				end					
	
	jlr: begin next_state=read; end

	regw_frm_aluout: begin next_state=read; end
	
	lhi_execute: begin next_state=read; end
	
	i_type_load: begin next_state=read; end
	
	//i_type_regwrite: begin next_state=read; end
	
	i_type_store: begin next_state= read; end
	
	br_yes: begin next_state= read; end

	jmp_store_pc: begin next_state = read; end

	default: next_state = state_reset;

		endcase
end

always @ (state ,out_en) begin
       
	case(state)
	//===============================================================================================
	state_reset:
		  begin
	  mem_read <= 1'b0;
	  mem_write <= 1'b0;
	  R_pc <= 2'b11;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b11;
	  regdst <= 2'b10;
	  reg_w <= 1'b0;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c<=2'b00;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
	
	read:
	  
	  begin
	  mem_read <= 1'b1;
	  mem_write <= 1'b0;
	  R_pc <= 2'b11;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b11;
	  regdst <= 2'b10;
	  reg_w <= 1'b1;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b1;
	  alu_op <= 2'b00;
	  b_c<=2'b00;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
//===============================================================================================	

	
	 	decode:
	  begin
	  mem_read <= 1'b0;    //dc
	  mem_write <= 1'b0;   //dc
	  R_pc <= 2'b00;          
	  alusrc_a <= 1'b1;    
	  alusrc_b <= 2'b11;  
	  regdst <= 2'b10;    //dc              //dekh lena
	  reg_w <= 1'b0;      
	  memtoreg <= 2'b10;   //dc 
	  i_d <= 2'b00;  			//dc
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;      //dc
	  b_c<=2'b00;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end	 	
 

//===============================================================================================
	LM1:
	  
	  begin
	  mem_read <= 1'b1;
	  mem_write <= 1'b0;
	  R_pc <= 2'b10;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b10;
	  regdst <= 2'b11;		//counter
	  reg_w <= 1'b0;
	  memtoreg <= 2'b00;		//dc
	  i_d <= 2'b11;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c<=2'b10;				//dc
	  ccr_update<=1'b0;
	  enbl<=1;
	  regA_in<=0;
	  end
//===============================================================================================	
LM2:
	  
	  begin
	  mem_read <= 1'b1;
	  mem_write <= 1'b0;
	  R_pc <= 2'b10;         
	  alusrc_a <= 1'b0;
	  alusrc_b <= 2'b11;
	  regdst <= 2'b11;		//encoder
	  reg_w <= out_en;
	  memtoreg <= 2'b00;
	  i_d <= 2'b01;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c<=2'b00;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=1;
	  end
//===============================================================================================	
SM1:
	  
	  begin
	  mem_read <= 1'b1;
	  mem_write <= 1'b0;
	  R_pc <= 2'b10;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b10;
	  regdst <= 2'b11;		//counter
	  reg_w <= 1'b0;
	  memtoreg <= 2'b00;		//dc
	  i_d <= 2'b11;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c<=2'b10;				//dc
	  ccr_update<=1'b0;
	  enbl<=1;
	  regA_in<=0;
	  end
//===============================================================================================	
SM2:
	  
	  begin
	  mem_read <= 1'b0;
	  mem_write <= out_en;
	  R_pc <= 2'b10;         
	  alusrc_a <= 1'b0;
	  alusrc_b <= 2'b11;
	  regdst <= 2'b11;		//counter
	  reg_w <= 1'b0;
	  memtoreg <= 2'b00;
	  i_d <= 2'b01;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c<=2'b10;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=1;
	  end
//===============================================================================================		
	
	add:
	  begin
	  mem_read <= 1'b0;    //dc
	  mem_write <= 1'b0;   //dc
	  R_pc <= 2'b10;          
	  alusrc_a <= 1'b0;    
	  alusrc_b <= 2'b00;  
	  regdst <= 2'b00;    //dc              //dekh lena
	  reg_w <= 1'b0;      
	  memtoreg <= 2'b10;   //dc 
	  i_d <= 2'b00;  			//dc
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;
	  b_c<=2'b01;
	  ccr_update<=1'b1;
	  enbl<=0;
	  regA_in<=0;
	  end
//===============================================================================================
	regw_frm_aluout:
	  begin
	  mem_read <= 1'b0;    //dc
	  mem_write <= 1'b0;   //dc
	  R_pc <= 2'b10;        //dc    
	  alusrc_a <= 1'b0;    //dc  
	  alusrc_b <= 2'b00;   //dc
	  regdst <= 2'b00;                  //dekh lena
	  reg_w <= 1'b1;      
	  memtoreg <= 2'b10;   
	  i_d <= 2'b00;  			//dc
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;
	  b_c<=2'b01;
	  ccr_update<=1'b0;
		enbl<=0;
	  regA_in<=0;
	  end		  
	  
//===============================================================================================
	nanda:
	  begin
	  mem_read <= 1'b0;    //dc
	  mem_write <= 1'b0;   //dc
	  R_pc <= 2'b10;          
	  alusrc_a <= 1'b1;    
	  alusrc_b <= 2'b00;  
	  regdst <= 2'b00;    //dc              //dekh lena
	  reg_w <= 1'b1;      
	  memtoreg <= 2'b10;   //dc 
	  i_d <= 2'b00;  			//dc
	  ir_w <= 1'b0;	
	  alu_op <= 2'b10;
	  b_c<=2'b01;
	  ccr_update<=1'b0;
		enbl<=0;
	  regA_in<=0;
	  end	  

//===============================================================================================
	lhi_execute:
	  begin
	  mem_read <= 1'b1;    //dc
	  mem_write <= 1'b0;   //dc
	  R_pc <= 2'b00;          
	  alusrc_a <= 1'b0;    //dc   
	  alusrc_b <= 2'b00;   //dc
	  regdst <= 2'b01;              
	  reg_w <= 1'b1;      
	  memtoreg <= 2'b11;    
	  i_d <= 2'b00;  			//dc
	  ir_w <= 1'b0;	      //dc
	  alu_op <= 2'b10;      //dc
	  b_c<=2'b00;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end	 	  
	  
//===============================================================================================

	
//===============================================================================================

	  
  
//===============================================================================================
	adi_execute:
	  begin
	  mem_read <= 1'b0;     //dc
	  mem_write <= 1'b0;    //dc
	  R_pc <= 2'b00;                 
	  alusrc_a <= 1'b0;         
	  alusrc_b <= 2'b01;  
	  regdst <= 2'b01;                  //dekh lena
	  reg_w <= 1'b1;      
	  memtoreg <= 2'b10;    
	  i_d <= 2'b00;      //dc 			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;
	  b_c<=2'b11;        //
	  ccr_update<=1'b1;
	  enbl<=0;
	  regA_in<=0;
	  end	  
	  
//===============================================================================================
	lw_execute:
	  begin
	  mem_read <= 1'b1;     //dc
	  mem_write <= 1'b0;    //dc
	  R_pc <= 2'b00;                 
	  alusrc_a <= 1'b0;         
	  alusrc_b <= 2'b01;  
	  regdst <= 2'b01;    //dc              //dekh lena
	  reg_w <= 1'b1;      
	  memtoreg <= 2'b00;   //dc 
	  i_d <= 2'b11;      //dc 			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;
	  b_c<=2'b11;        //
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end	  
	  
//===============================================================================================
	sw_execute:
	  begin
	  mem_read <= 1'b0;     //dc
	  mem_write <= 1'b0;    //dc
	  R_pc <= 2'b00;                 
	  alusrc_a <= 1'b0;         
	  alusrc_b <= 2'b01;  
	  regdst <= 2'b10;    //dc              //dekh lena
	  reg_w <= 1'b0;      
	  memtoreg <= 2'b11;   //dc 
	  i_d <= 2'b00;      //dc 			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;
	  b_c<=2'b11;        //
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end	  
	  
//===============================================================================================

//	 
	
 
	 
//===============================================================================================
	i_type_load:
	  begin
	  
	  mem_read <= 1'b0;     
	  mem_write <= 1'b0;   
	  R_pc <= 2'b10;                 
	  alusrc_a <= 1'b0;  //dc       
	  alusrc_b <= 2'b10;  //dc
	  regdst <= 2'b01;                 //dekh lena
	  reg_w <= 1'b0;      
	  memtoreg <= 2'b00;      
	  i_d <= 2'b11;  			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;     //dc
	  b_c<=2'b00;	
	  ccr_update<=1'b1;
	  enbl<=0;
	  regA_in<=0;
	  end		
	 
//===============================================================================================
	i_type_store:
	  begin
     mem_read <= 1'b0;     
	  mem_write <= 1'b1;   
	  R_pc <= 2'b00;      //dc           
	  alusrc_a <= 1'b0;  //dc       
	  alusrc_b <= 2'b01;  //dc
	  regdst <= 2'b01;      //dc           //dekh lena
	  reg_w <= 1'b0;          
	  memtoreg <= 2'b00;      
	  i_d <= 2'b11;  			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b00;     //dc
	  b_c<=2'b11;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end	

//===============================================================================================
//	i_type_regwrite:
//	  begin
//	  mem_read <= 1'b1;   //dc   
//	  mem_write <= 1'b0;  
//	  R_pc <= 2'b00;                 
//	  alusrc_a <= 1'b0;  //dc       
//	  alusrc_b <= 2'b01;  //dc
//	  regdst <= 2'b01;                 //dekh lena
//	  reg_w <= 1'b1;      
//	  memtoreg <= 2'b00;    
//	  i_d <= 2'b11;  			
//	  ir_w <= 1'b0;	
//	  alu_op <= 2'b00;     //dc
//	  b_c<=2'b00;
//	  ccr_update<=1'b0;
//	  enbl<=0;
//	  end	

//===============================================================================================
   branch_compare: 
    begin
	  mem_read <= 1'b0;     //dc
	  mem_write <= 1'b0;    //dc
	  R_pc <= 2'b00;                 
	  alusrc_a <= 1'b0;         
	  alusrc_b <= 2'b00;  
	  regdst <= 2'b10;    //dc              //dekh lena
	  reg_w <= 1'b0;      //dc
	  memtoreg <= 2'b00;   //dc 
	  i_d <= 2'b00;      //dc 			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b01;
	  b_c<=2'b11;        //
	  ccr_update<=1'b1;
	  enbl<=0;
	  regA_in<=0;
	  end	
	  
//===============================================================================================
   br_check: 
    begin
	  mem_read <= 1'b0;     //dc
	  mem_write <= 1'b0;    //dc
	  R_pc <= 2'b00;                 
	  alusrc_a <= 1'b0;         
	  alusrc_b <= 2'b00;  
	  regdst <= 2'b10;    //dc              //dekh lena
	  reg_w <= 1'b0;      //dc
	  memtoreg <= 2'b00;   //dc 
	  i_d <= 2'b00;      //dc 			
	  ir_w <= 1'b0;	
	  alu_op <= 2'b01;
	  b_c<=2'b11;        //
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end		  
//===============================================================================================	  
   br_yes:
	  begin
	  mem_read <= 1'b0;
	  mem_write <= 1'b0;
	  R_pc <= 2'b11;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b01;
	  regdst <= 2'b10;
	  reg_w <= 1'b1;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c <=2'b11;   //dc
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
//===============================================================================================	  
   jmp_add:
	  begin
	  mem_read <= 1'b0;
	  mem_write <= 1'b0;
	  R_pc <= 2'b11;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b10;	//+0
	  regdst <= 2'b01;
	  reg_w <= 1'b1;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c <=2'b11;   //dc
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
//===============================================================================================	  
   jmp_store_pc:
	  begin
	  mem_read <= 1'b0;
	  mem_write <= 1'b0;
	  R_pc <= 2'b11;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b01;
	  regdst <= 2'b10;
	  reg_w <= 1'b1;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c <=2'b11;   //dc
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
	  
//===============================================================================================	  
   jlr:
	  begin
	  mem_read <= 1'b0;
	  mem_write <= 1'b0;
	  R_pc <= 2'b00;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b10;
	  regdst <= 2'b10;
	  reg_w <= 1'b1;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b0;
	  alu_op <= 2'b00;
	  b_c <=2'b00;   //dc
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
	  
	  default:
		begin
	  mem_read <= 1'b1;
	  mem_write <= 1'b0;
	  R_pc <= 2'b11;         
	  alusrc_a <= 1'b1;
	  alusrc_b <= 2'b11;
	  regdst <= 2'b10;
	  reg_w <= 1'b1;
	  memtoreg <= 2'b10;
	  i_d <= 2'b00;
	  ir_w <= 1'b1;
	  alu_op <= 2'b00;
	  b_c<=2'b00;
	  ccr_update<=1'b0;
	  enbl<=0;
	  regA_in<=0;
	  end
endcase
	  end

endmodule	  
