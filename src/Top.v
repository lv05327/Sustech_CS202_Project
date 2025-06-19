`timescale 1ns / 1ps
module Top(
    input fpga_rst,
    input fpga_clk,
    input [15:0] ioread_data_switch,
    input enter,
    input continue,
    output [7:0] led_out,
    output [7:0] seg_en,
    output [7:0] seg_out0,
    output [7:0] seg_out1,
    
    //U-art
    input start_pg, //start program, active high
    input upg_rx, //receive data by U-art
    output upg_tx //send data by U-art
    );

    wire clk;
    wire ebreak;
    // IFetch
    wire Branch;
    wire DoBranch;
    wire [31:0] imm32;
    wire [31:0] inst;
    wire [31:0] PC_4;
    wire Jal;
    wire Jr;
    wire nBranch;
    wire isIOReadOK;

    // Controller
    wire MemRead;
    wire MemorIOtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire [2:0] ALUOp;

    // Decoder
    wire [31:0] rs1Data;
    wire [31:0] rs2Data;

    // ALU
    wire [31:0] ALUResult;

    // DataMem

    // MemOrIO
    wire ioRead;           
    wire ioWrite;                   
    wire [31:0] addr_out;        
    wire [31:0] m_rdata;         
    wire [7:0] io_rdata;        
    wire [31:0] r_wdata;                 
    wire [31:0] write_data;   
    wire LEDCtrl;
    wire SEGCtrl16;
    wire SEGCtrl10;
    wire switchCtrl1;
    wire switchCtrl2; 
    
    // ioread

    //U-art
    wire rst;
    wire upg_clk, upg_clk_o;
    wire upg_wen_o;     //Uart write out enable
    wire upg_done_o;    //Uart rx data have done
    wire [14:0] upg_adr_o;      //data to which  memory unit of program_rom/dmemory32
    wire [31:0] upg_dat_o;      //data to program_rom/dmemory32 
    wire spg_bufg;
    reg upg_rst;
    
    BUFG pg(.I(start_pg),.O(spg_bufg));
    always @(posedge clk) begin
        if (!fpga_rst) upg_rst <= 1;
        if (spg_bufg) upg_rst <= 0;
    end
    assign rst = fpga_rst & upg_rst;
    uart_ips uart(.upg_clk_i(upg_clk),.upg_rst_i(upg_rst),.upg_rx_i(upg_rx),.upg_clk_o(upg_clk_o),.upg_wen_o(upg_wen_o),
                  .upg_adr_o(upg_adr_o),.upg_dat_o(upg_dat_o),.upg_done_o(upg_done_o),.upg_tx_o(upg_tx));
    clk_wiz_0 clk_u(.clk_in1(fpga_clk), .clk_out1(clk),.clk_out2(upg_clk));
    IFetch ift(.Jal(Jal),.Jr(Jr),.PC_jalr(ALUResult),.PC_4(PC_4),.clk(clk),.rst(rst),.Branch(Branch),.DoBranch(DoBranch),.imm32(imm32),.inst(inst),.isIOReadOK(isIOReadOK),.IORead(ioRead),.continue(continue),.ebreak(ebreak),
               .upg_rst_i(upg_rst),.upg_clk_i(upg_clk_o),.upg_wen_i(upg_wen_o & !upg_adr_o[14]),.upg_adr_i(upg_adr_o[13:0]),.upg_dat_i(upg_dat_o),.upg_done_i(upg_done_o));
    Controller ct(.IORead(ioRead),.IOWrite(ioWrite),.MemorIOtoReg(MemorIOtoReg),.Jr(Jr),.Jal(Jal),.inst(inst),.Alu_resultHigh(ALUResult[31:10]),.MemRead(MemRead),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.ALUOp(ALUOp),.ebreak(ebreak),.Branch(Branch));
    Decoder dec(.clk(clk),.rst(rst),.regWrite(RegWrite),.inst(inst),.write_data(r_wdata),.PC_4(PC_4),.rs1Data(rs1Data),.rs2Data(rs2Data),.imm32(imm32));
    ALU alu(.ALUOp(ALUOp),.ALUSrc(ALUSrc),.ReadData1(rs1Data),.ReadData2(rs2Data),.imm32(imm32),.ALUResult(ALUResult),.DoBranch(DoBranch),.funct3(inst[14:12]),.funct7(inst[31:25]));
    DataMem dm(.clk(clk),.MemRead(MemRead),.MemWrite(MemWrite),.addr(addr_out),.din(write_data),.dout(m_rdata),
               .upg_rst_i(upg_rst),.upg_clk_i(upg_clk_o),.upg_wen_i(upg_wen_o & upg_adr_o[14]),.upg_adr_i(upg_adr_o[13:0]),.upg_dat_i(upg_dat_o),.upg_done_i(upg_done_o));
    MemOrIO moi(.inst(inst),.mRead(MemRead),.mWrite(MemWrite),.ioRead(ioRead),.ioWrite(ioWrite),.addr_in(ALUResult),.addr_out(addr_out),.m_rdata(m_rdata),.io_rdata(io_rdata),.r_wdata(r_wdata),.r_rdata(rs2Data),.write_data(write_data),.LEDCtrl(LEDCtrl),.SEGCtrl16(SEGCtrl16),.SEGCtrl10(SEGCtrl10),.switchCtrl1(switchCtrl1),.switchCtrl2(switchCtrl2),.ALUResult(ALUResult));
    ioread ir(.enter(enter),.clk(clk),.reset(rst),.ior(ioRead),.switchCtrl1(switchCtrl1),.switchCtrl2(switchCtrl2),.ioread_data_switch(ioread_data_switch),.ioread_data(io_rdata),.isIOReadOK(isIOReadOK));
    leds led(.led_rst(rst),.clk(clk),.led_write(ioWrite),.led_cs(LEDCtrl),.led_data(write_data),.led_out(led_out));
    segs seg(.seg_rst(rst),.clk(clk),.seg_clk(fpga_clk),.seg_write(ioWrite),.seg_cs16(SEGCtrl16),.seg_cs10(SEGCtrl10),.seg_data(write_data),.seg_en(seg_en),.seg_out0(seg_out0),.seg_out1(seg_out1));
endmodule