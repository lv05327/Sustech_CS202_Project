`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 22:25:24
// Design Name: 
// Module Name: Decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder_test(clk, rst, led);
    input clk, rst; //clk and reset, active low
    wire regWrite = 1; // register write enable, active high
    output reg led;
    reg [31:0] rs1Data, rs2Data, imm32; // register1 data, register2 data, 32-bit immediate number
    
    wire [31:0] inst = 32'hff9f_f06f;
    wire [31:0] write_data = 32'h0000_0000;
    wire [31:0] PC_4 = 32'h0040_0024;
    
    integer i;
    reg [31:0] register[0:31];  // 32 general-purpose registers
    
    // Extract opcode from instruction (bits [6:0])
    wire [6:0] opcode;
    assign opcode = inst[6:0];
    
    // Extract funct3 from instruction (bits [14:12])
    wire [2:0] funct3;
    assign funct3 = inst[14:12];
    
    // Extract funct7 from instruction (bits [31:25])
    wire [6:0] funct7;
    assign funct7 = inst[31:25];
    
    reg [31:0] write_data_r;
    
    always @(*) begin
        if (opcode == 7'b1101111 || opcode == 7'b1100111) begin
            write_data_r = PC_4;
        end 
        else begin
            write_data_r = write_data;
        end
        if (write_data_r == PC_4) begin
            led = 1;
        end
    end
    
    always @(*) begin
        case (opcode)
            // R-type instructions (add, sub, xor, or, and, sll, srl, sra, slt, sltu)
            7'b0110011: begin
                rs1Data = register[inst[19:15]];  // rs1
                rs2Data = register[inst[24:20]];  // rs2
                imm32 = 0;  // No immediate for R-type
            end
            
            // I-type instructions (addi, xori, ori, andi, slli, srli, srai, slti, sltiu, loads, jalr)
            7'b0010011, 7'b0000011: begin
                rs1Data = register[inst[19:15]];  // rs1
                // Sign-extend the 12-bit immediate
                imm32 = {{20{inst[31]}}, inst[31:20]};
                
                // Special handling for shift immediate instructions (slli, srli, srai)
                if (opcode == 7'b0010011 && (funct3 == 3'b001 || funct3 == 3'b101)) begin
                    imm32 = {27'b0, inst[24:20]};  // Only bits [4:0] are used for shift amount
                end
            end
            
            // S-type instructions (sb, sh, sw)
            7'b0100011: begin
                rs1Data = register[inst[19:15]];  // rs1
                rs2Data = register[inst[24:20]];  // rs2
                // Sign-extend the 12-bit immediate (formed by bits [31:25] and [11:7])
                imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end
            
            // B-type instructions (beq, bne, blt, bge, bltu, bgeu)
            7'b1100011: begin
                rs1Data = register[inst[19:15]];  // rs1
                rs2Data = register[inst[24:20]];  // rs2
                // Sign-extend the 13-bit immediate (bits are reordered in B-type)
                imm32 = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            end
            
            // U-type instructions (lui, auipc)
            7'b0110111, 7'b0010111: begin
                // Immediate is 20 bits shifted left by 12 bits
                imm32 = {inst[31:12], 12'b0};
            end
            
            // J-type instruction (jal)
            7'b1101111: begin
                // Sign-extend the 21-bit immediate (bits are reordered in J-type)
                imm32 = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            end
            
            // jalr
            7'b1100111: begin
                rs1Data = register[inst[19:15]];  // rs1
                // Sign-extend the 12-bit immediate
                imm32 = {{20{inst[31]}}, inst[31:20]};
            end
            
            // Environment instructions (ecall, ebreak)
            7'b1110011: begin
                imm32 = 0;  // No immediate for these instructions
            end
            
            default: begin
                rs1Data = 0;
                rs2Data = 0;
                imm32 = 0;
            end
        endcase
    end
    
    // Register file update logic
    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            // Reset all registers to 0
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 0;
            end
        end
        else begin
            // Write to register if regWrite is enabled and destination is not x0
            if (regWrite == 1'b1 && inst[11:7] != 0) begin
                register[inst[11:7]] <= write_data_r;
            end
        end
    end
endmodule
