module pipelined_risc_processor(
input clk,
input reset

    );
//program counter    
reg[7:0]pc;

//instruction memory
reg[15:0]instr_mem[0:255];

//current instruction memory
reg[15:0] instruction;

//register file
reg[7:0] reg_file[0:7];

//instruction fetch stage
always@(posedge clk)
begin
    if(reset)
      pc <= 0;
    else
      pc <= pc + 1;
      
    instruction <= instr_mem[pc];
 end
 
//Decode stage
reg[3:0]opcode;
reg[2:0]rd,rs1,rs2;

always@(posedge clk)
begin 
     opcode <= instruction[15:12];
     rd     <= instruction[11:9];
     rs1    <= instruction[8:6];
     rs2    <= instruction[5:3];
 end 
 
//Execute stage(ALU)
reg[7:0] alu_result;

always @(posedge clk)
begin
     case(opcode)
     
          4'b0000: alu_result <= reg_file[rs1] + reg_file[rs2];
          4'b0001: alu_result <= reg_file[rs1] - reg_file[rs2];
          4'b0010: alu_result <= reg_file[rs1] & reg_file[rs2];
          4'b0011: alu_result <= reg_file[rs1] | reg_file[rs2];
          
          default: alu_result = 0;
     endcase
end

//Memory stage

reg[7:0] mem_data;

always @(posedge clk)
begin
     reg_file[rd] <= mem_data;
end 
endmodule
