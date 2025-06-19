`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 15:09:27
// Design Name: 
// Module Name: segs
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


module segs (
    input seg_rst,	// reset, active high
    input seg_clk,	// clk for seg
    input clk,      // clk of cpu
    input seg_write,	// seg write enable, active high
    input seg_cs16,	// 1 means the leds are selected as output
    input seg_cs10,
    input [31:0] seg_data,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output [7:0] seg_en,
    output [7:0] seg_out0,
    output [7:0] seg_out1
);
    reg [31:0] new_data;
    reg cs16, cs10;
    wire [31:0] write_data;
    wire [4:0] radix;
    always @ (posedge clk, negedge seg_rst) begin
        if (!seg_rst) begin
            new_data <= 0;
            cs16 <= 0;
            cs10 <= 0;
        end
        else if (seg_write&&(seg_cs16|seg_cs10)) begin
            new_data <= seg_data;
            cs16 <= seg_cs16;
            cs10 <= seg_cs10;
        end
    end
    data_parser parser(.rst(seg_rst),.cs16(cs16),.cs10(cs10),.new_data(new_data),.write_data(write_data),.radix(radix));
    scan_seg scan_seg_u(.clk(seg_clk),.rst(seg_rst),.radix(radix),.seg_data(write_data),.seg_en(seg_en),.seg_out0(seg_out0),.seg_out1(seg_out1));
endmodule
