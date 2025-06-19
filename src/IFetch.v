`timescale 1ns / 1ps
module IFetch (
    input wire clk,     
    input wire rst,
    input wire Jal,                     //是否要进行Jal类型的跳转       
    input wire Jr,                      //是否要进行Jalr类型的跳转
    input wire Branch,                  //当前指令是不是B型指令
    input wire DoBranch,                //是否要跳转
    input wire [31:0] imm32,            //32位立即数，源自Decoder
    input wire [31:0] PC_jalr,          //jalr的跳转目标，源自ALU的计算结果
    input wire isIOReadOK,              //判断IO是否结束
    input wire IORead,                  //判断是否是IO
    input exit,                         //判断现在程序的状态
    input ebreak,                       //决定当前指令是否中断
    input continue,                     //与按键绑定，控制程序恢复正常运行
    output wire [31:0] PC_4,            //当前PC+4 的结果，用于跳转，传递给Decoder写入寄存器
    output wire [31:0] inst,            //当前运行的指令
    
    //ports for U-art
    input upg_rst_i,
    input upg_clk_i,
    input upg_wen_i,
    input [13:0] upg_adr_i,
    input [31:0] upg_dat_i,
    input upg_done_i
);
    reg [31:0] PC_4_latch;
    reg [31:0] pc;   //当前PC寄存器的值
    localparam ROM_MAX_ADDR = 32'h0000FFFF;
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    blk_mem_gen_0 u_rom (
        .clka(kickOff ? clk : upg_clk_i),
        .wea(kickOff ? 1'b0 : upg_wen_i),
        .addra(kickOff ? pc[15:2] : upg_adr_i),
        .dina(kickOff ? 32'h0000_0000 : upg_dat_i),
        .douta(inst)
    );
    wire pos;
    the_trigger u_trigger(
        .clk(clk),
        .trig(continue),
        .pos(pos)
    );
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            pc <= 32'h00000000;
        end else if (exit) begin
            pc <= pc;
        end else if (ebreak && !pos) begin
            pc <= pc;
        end else if (pc[1:0] != 2'b00 || pc > ROM_MAX_ADDR) begin
            pc <= 32'h00000000;
        end else if (Jr) begin
            pc <= PC_jalr;
        end else if (Jal) begin
            pc <= pc + imm32;
        end else if (Branch && DoBranch) begin
            pc <= pc + imm32;
        end else if (IORead && !isIOReadOK) begin
            pc <= pc;
        end else begin
            pc <= pc + 4;
        end
    end    
    
    always @(negedge clk or negedge rst) begin//增加锁存器，储存PC+4,防止由于时序问题在寄存器中写入跳转后的PC+4值
        if (!rst)
            PC_4_latch <= 0;
        else
            PC_4_latch <= pc + 4;  // 在negedge采样pc+4
    end

    assign PC_4 = PC_4_latch;

endmodule