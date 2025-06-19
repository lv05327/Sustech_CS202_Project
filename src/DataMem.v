`timescale 1ns / 1ps
module DataMem(
    input clk,                                  
    input MemRead,MemWrite,
    input [31:0] addr,               //the address process
    input [31:0] din,                //the data input
    output [31:0] dout,              //the data output
    
    //ports for U-art
    input upg_rst_i,
    input upg_clk_i,
    input upg_wen_i,
    input [13:0] upg_adr_i,
    input [31:0] upg_dat_i,
    input upg_done_i
);
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    RAM udram(.clka(kickOff ? ~clk : upg_clk_i),
              .wea(kickOff ? MemWrite : upg_wen_i),
              .addra(kickOff ? addr[15:2] : upg_adr_i),
              .dina(kickOff ? din : upg_dat_i),
              .douta(dout)); 
endmodule
