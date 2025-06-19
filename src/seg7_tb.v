`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 22:09:57
// Design Name: 
// Module Name: seg7_tb
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


module seg7_tb();
    reg clk;
    reg rst;
    reg [31:0] seg_data;
    wire [7:0] seg_en;
    wire [7:0] seg_out0;
    wire [7:0] seg_out1;
    
    scan_seg seg_tb(.clk(clk),.rst(rst),.seg_data(seg_data),.seg_en(seg_en),.seg_out0(seg_out0),.seg_out1(seg_out1));
    
    initial begin
        clk = 0;
        rst = 0;
        seg_data = 0;
    end
    
    always #5 clk = ~clk;
    
    initial begin
        #10 rst = 1;
        #10 seg_data = 32'h0000_0004;
    end
endmodule
