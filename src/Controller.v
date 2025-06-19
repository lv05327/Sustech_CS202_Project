`timescale 1ns / 1ps
module Controller(
    input [31:0] inst,          //��ǰִ�е�ָ��
    input [21:0] Alu_resultHigh,    //ALU����ĵ�ַ�ĸ�λ�������ж��Ƿ���IO����
    output reg Jr,              //�Ƿ���JRָ��
    output reg Jal,             //�Ƿ���JALָ��
    output reg MemorIOtoReg,    //��ʾ����Ĵ�����ֵ����Դ
    output reg Branch,          //�Ƿ�����תָ��
    output reg RegWrite,        //�Ƿ���д�Ĵ���ָ��
    output reg MemRead,         //�Ƿ���ڴ�
    output reg MemWrite,        //�Ƿ�д�ڴ�
    output reg IORead,          //�Ƿ���IO������
    output reg IOWrite,         //�Ƿ���IOд����
    output reg ALUSrc,          //��������ALU�Ĳ�����Դ���ǽ�������������ǼĴ���
    output reg [2:0] ALUOp,     //ALU������
    output reg ebreak           //�����Ƿ����ж�ָ��
);

    wire IsIO = (Alu_resultHigh == 22'b1111_1111_1111_1111_1111_10);
    wire [6:0] opcode;
    assign opcode = inst[6:0];
    always @(*) begin   
        // Ĭ�ϰ�ȫֵ
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
                // Ĭ��ȫ����ȫֵ
            end
        endcase
    end
endmodule