`timescale 1ns / 1ps

module MemOrIO(
    inst,mRead,mWrite,ioRead,ioWrite,addr_in,addr_out,m_rdata,io_rdata,r_wdata,r_rdata,write_data,LEDCtrl,SEGCtrl16,SEGCtrl10,switchCtrl1,switchCtrl2,ALUResult
);
    input [31:0] inst;
    input mRead;             //read memory,from Controller
    input mWrite;            //write memory,from Controller
    input ioRead;           //read I/O,from Controller
    input ioWrite;          //write I/O,from Controller
    input [31:0] ALUResult;  //ALUResult from ALU
    input[31:0] addr_in;          //from alu_result in ALU
    output[31:0] addr_out;         //address to Data-Memory

    input[31:0] m_rdata;          //data read from Data-Memory
    input[7:0] io_rdata;         //data read from IO,8 bits
    output [31:0] r_wdata;          //data to Decoder(register file)

    input[31:0] r_rdata;         //data from Decoder(register file)
    output reg [31:0] write_data;      //data to memory or I/O (m_wdata, io_wdata)
    output LEDCtrl;              //LED Chip Select
    output SEGCtrl16;              //7-segment16 display Chip Select
    output SEGCtrl10;              //7-segment10 display Chip Select
    output switchCtrl1;           //Switch1 Chip Select
    output switchCtrl2;           //Switch2 Chip Select

    assign addr_out = addr_in;    //address to Data-Memory
    assign r_wdata = mRead ? (ioRead ? inst[14:12] == 0 ? io_rdata[7] == 1 ? {24'b111111111111111111111111,io_rdata} : {24'b0,io_rdata} : {24'b0,io_rdata} : m_rdata) : ALUResult;    // read data from memory or I/O

    assign LEDCtrl = addr_out == 32'hFFFF_F820 ? 1'b1 : 1'b0; // LED Chip Select
    assign SEGCtrl16 = addr_out == 32'hFFFF_F830 ? 1'b1 : 1'b0; // 7-segment16 display Chip Select
    assign SEGCtrl10 = addr_out == 32'hFFFF_F840 ? 1'b1 : 1'b0; // 7-segment10 display Chip Select
    assign switchCtrl1 = addr_out == 32'hFFFF_F800 ? 1'b1 : 1'b0; // Switch1 Chip Select
    assign switchCtrl2 = addr_out == 32'hFFFF_F810 ? 1'b1 : 1'b0; // Switch2 Chip Select

    always @* begin
        if((mWrite==1)||(ioWrite==1))
            write_data = r_rdata;    // write data to memory or I/O
        else
            write_data = 32'hZZZZZZZZ;     // no write operation
    end
endmodule