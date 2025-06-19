`timescale 1ns / 1ps
module IFetch (
    input wire clk,     
    input wire rst,
    input wire Jal,                     //�Ƿ�Ҫ����Jal���͵���ת       
    input wire Jr,                      //�Ƿ�Ҫ����Jalr���͵���ת
    input wire Branch,                  //��ǰָ���ǲ���B��ָ��
    input wire DoBranch,                //�Ƿ�Ҫ��ת
    input wire [31:0] imm32,            //32λ��������Դ��Decoder
    input wire [31:0] PC_jalr,          //jalr����תĿ�꣬Դ��ALU�ļ�����
    input wire isIOReadOK,              //�ж�IO�Ƿ����
    input wire IORead,                  //�ж��Ƿ���IO
    input exit,                         //�ж����ڳ����״̬
    input ebreak,                       //������ǰָ���Ƿ��ж�
    input continue,                     //�밴���󶨣����Ƴ���ָ���������
    output wire [31:0] PC_4,            //��ǰPC+4 �Ľ����������ת�����ݸ�Decoderд��Ĵ���
    output wire [31:0] inst,            //��ǰ���е�ָ��
    
    //ports for U-art
    input upg_rst_i,
    input upg_clk_i,
    input upg_wen_i,
    input [13:0] upg_adr_i,
    input [31:0] upg_dat_i,
    input upg_done_i
);
    reg [31:0] PC_4_latch;
    reg [31:0] pc;   //��ǰPC�Ĵ�����ֵ
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
    
    always @(negedge clk or negedge rst) begin//����������������PC+4,��ֹ����ʱ�������ڼĴ�����д����ת���PC+4ֵ
        if (!rst)
            PC_4_latch <= 0;
        else
            PC_4_latch <= pc + 4;  // ��negedge����pc+4
    end

    assign PC_4 = PC_4_latch;

endmodule