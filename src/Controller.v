`timescale 1ns / 1ps
module Controller(
    input [31:0] inst,          //当前执行的指令
    input [21:0] Alu_resultHigh,    //ALU计算的地址的高位，用于判断是否是IO操作
    output reg Jr,              //是否是JR指令
    output reg Jal,             //是否是JAL指令
    output reg MemorIOtoReg,    //表示存入寄存器的值的来源
    output reg Branch,          //是否是跳转指令
    output reg RegWrite,        //是否是写寄存器指令
    output reg MemRead,         //是否读内存
    output reg MemWrite,        //是否写内存
    output reg IORead,          //是否是IO读操作
    output reg IOWrite,         //是否是IO写操作
    output reg ALUSrc,          //决定下游ALU的操作来源，是解码的立即数还是寄存器
    output reg [2:0] ALUOp,     //ALU操作码
    output reg ebreak           //决定是否是中断指令
);

    wire IsIO = (Alu_resultHigh == 22'b1111_1111_1111_1111_1111_10);
    wire [6:0] opcode;
    assign opcode = inst[6:0];
    always @(*) begin   
        // 默认安全值
        Jr = 0;
        Jal = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        MemorIOtoReg = 0;
        IORead = 0;
        IOWrite = 0;
        ALUSrc = 0;
        ALUOp = 3'b000;
        ebreak = 0;
        Branch = 0;
        case (opcode)
            7'b0110011: begin // R-type (add, sub, etc.)
                RegWrite = 1;
                ALUSrc = 0;
                ALUOp = 3'b010;
            end
            7'b0010011: begin // I-type ALU (addi, andi, etc.)
                RegWrite = 1;
                ALUSrc = 1;
                ALUOp = 3'b010;
            end
            7'b0000011: begin // Load (lw, lb, etc.)
                RegWrite = 1;
                ALUSrc = 1;
                ALUOp = 3'b000;
                MemRead = 1;
                if (IsIO) IORead = 1;
                MemorIOtoReg = 1;
            end
            7'b0100011: begin // Store (sw, sb, etc.)
                ALUSrc = 1;
                ALUOp = 3'b000;
                if (IsIO) IOWrite = 1;
                else MemWrite = 1;
            end
            7'b1100011: begin// Branch (blt,beq,bne,etc.)
                ALUOp = 3'b001;
                Branch = 1;
            end

           7'b1101111: begin // JAL
                RegWrite = 1;
                Jal = 1;
                ALUSrc = 1;
                ALUOp = 3'b000; 
            end
            7'b1100111: begin // JALR
                RegWrite = 1;
                ALUSrc = 1;
                Jal = 1;
                Jr = 1;
                ALUOp = 3'b000;
            end
            7'b0010111: begin // AUIPC
                ALUOp = 3'b110;
                RegWrite = 1;
                ALUSrc = 1;
            end
            7'b0110111: begin//lui
                ALUOp = 3'b011;
                RegWrite = 1;
                ALUSrc = 1;
            end
            7'b1110011: begin
                if(inst[31:20]==1)begin
                ebreak = 1;//ebreak
                end
                else begin
                ALUOp = 3'b100;//ecall             
                IOWrite = 1;
                ALUSrc = 1;
                end
            end
            default: begin
                // 默认全部安全值
            end
        endcase
    end
endmodule