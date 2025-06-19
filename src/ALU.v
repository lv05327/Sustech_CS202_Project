module ALU(
    input wire [31:0] ReadData1,        //接收自Decoder的寄存器值
    input wire [31:0] ReadData2,        //接收自Decoder的寄存器值
    input wire [31:0] imm32,            //接收自Decoder解码的立即数
    input wire ALUSrc,                  //来自Controller的决定计算来源的值
    input wire [2:0] ALUOp,             //ALU操作码
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [31:0] ALUResult,
    output reg DoBranch                //传递给Ifetch的决定是否要进行跳转
);

    reg [4:0] ALUControl;
    wire [31:0] SrcB = (ALUSrc ? imm32 : ReadData2);
    always @(*) begin
        // 默认为非法行为，若为正确输入，值在后续会被更改
        ALUControl = 5'b11111;
        ALUResult = 32'hDEADBEEF;
        DoBranch = 1'b0;
        // ALU Control 解码
        case (ALUOp)
            3'b000: ALUControl = 5'b00010; // Load/Store：ADD
            3'b001: begin
            case (funct3)
                3'b000: ALUControl = 5'b00110;//beq
                3'b001: ALUControl = 5'b00111;//bne
                3'b100: ALUControl = 5'b01010;//blt
                3'b101: ALUControl = 5'b10001;//bge
                3'b110: ALUControl = 5'b10010;//bltu
                3'b111: ALUControl = 5'b10011;//bgeu
                endcase
                end
            3'b010: begin
                case (funct3)
                    3'b000: ALUControl = (funct7 == 7'b0100000) ? 5'b00110 :     // SUB
                                          (funct7 == 7'b0000001) ? 5'b01001 :     // MUL
                                          5'b00010;                               // ADD
                    3'b001: ALUControl = 5'b01000; // SLL
                    3'b010: ALUControl = 5'b01010; // SLT
                    3'b011: ALUControl = 5'b10010; //SLTU
                    3'b100: ALUControl = (funct7 == 7'b0000001) ? 5'b01101 : 5'b01100; // DIV or XOR
                    3'b101: ALUControl = (funct7 == 7'b0100000) ? 5'b01110 : 5'b01111; // SRA or SRL
                    3'b110: ALUControl = (funct7 == 7'b0000001) ? 5'b00011 : 5'b00001; // REM or OR
                    3'b111: ALUControl = 5'b00000; // AND
                endcase
            end
            3'b011: ALUControl = 5'b10100;//lui
            3'b110: ALUControl = 5'b00010;//auipc
            3'b100: 
            if(ReadData1==1)begin
               ALUControl = 5'b00100;   //ecall print操作
            end
            else begin
                ALUControl = 5'b00101;  //意外操作
            end
        endcase

        // ALU 运算
        case (ALUControl)
                5'b00000: ALUResult = ReadData1 & SrcB;               // and
                5'b00001: ALUResult = ReadData1 | SrcB;               // or
                5'b00010: ALUResult = ReadData1 + SrcB;               // add auipc
                5'b00011: ALUResult = ReadData1 % SrcB;               //mod
                5'b00100: ALUResult = 32'hFFFF_F840;                   
                5'b00101: begin                                       // ecall/exit
                    ALUResult = 32'hDEAD1234;
                end
                5'b00110: begin                                       // beq
                    ALUResult = ReadData1 - SrcB;
                    DoBranch = (ReadData1 == SrcB);
                end
                5'b00111: begin                                       // bne
                    ALUResult = ~(ReadData1 - SrcB);
                    DoBranch = (ReadData1 != SrcB);
                end
                5'b01000: ALUResult = ReadData1 << SrcB[4:0];         // sll
                5'b01001: ALUResult = s_mul(ReadData1, SrcB);         // mul
                5'b01010: begin                                       // slt blt
                    ALUResult = ($signed(ReadData1) < $signed(SrcB)) ? 32'b1 : 32'b0;
                    DoBranch = ($signed(ReadData1) < $signed(SrcB));
                end
                5'b01011: begin                                       // sltu
                    ALUResult = (ReadData1 < SrcB) ? 32'b1 : 32'b0;
                end
                5'b01100: ALUResult = ReadData1 ^ SrcB;               // xor
                5'b01101: ALUResult = ReadData1 / SrcB ;          //div
                5'b01110: ALUResult = $signed(ReadData1) >>> SrcB[4:0]; // sra
                5'b01111: ALUResult = ReadData1 >> SrcB[4:0];         // srl
                5'b10001: begin                                       // bge
                    ALUResult = ($signed(ReadData1) >= $signed(SrcB)) ? 32'b1 : 32'b0;
                    DoBranch = ($signed(ReadData1) >= $signed(SrcB));
                end
                5'b10010: begin                                       // bltu
                    ALUResult = (ReadData1 < SrcB) ? 32'b1 : 32'b0;
                    DoBranch = (ReadData1 < SrcB);
                end
                5'b10011: begin                                       // bgeu
                    ALUResult = (ReadData1 >= SrcB) ? 32'b1 : 32'b0;
                    DoBranch = (ReadData1 >= SrcB);
                end
                5'b10100: begin
                    ALUResult = SrcB;//lui
                    end
                default: begin
                    ALUResult = 32'hDEAD1234;
                    DoBranch = 1'b0;
                end
            endcase
    end
    // 有符号乘法
    function [31:0] s_mul;
        input [31:0] a, b;
        reg [31:0] abs_a, abs_b, result;
        reg sign;
        integer i;
        begin
            sign = a[31] ^ b[31]; // 结果符号
            abs_a = a[31] ? -a : a;
            abs_b = b[31] ? -b : b;
            result = 0;
            for (i = 0; i < 32; i = i + 1)
                if (abs_b[i])
                    result = result + (abs_a << i);
            s_mul = sign ? -result : result;
        end
    endfunction
endmodule

