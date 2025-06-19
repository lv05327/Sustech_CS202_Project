`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 03:03:31
// Design Name: 
// Module Name: scan_seg
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


module scan_seg(
    input clk,
    input rst,
    input [4:0] radix,
    input [31:0] seg_data,
    output reg [7:0] seg_en,
    output [7:0] seg_out0,
    output [7:0] seg_out1
);
reg [3:0] scan_cnt;

reg clkout;
reg [31:0] cnt;
parameter period = 200000;

always @(posedge clk, negedge rst) begin
    if (!rst) begin
        cnt <= 0;
        clkout <= 0;
    end
    else begin
        if (cnt==(period>>1)-1) begin
            clkout <= ~clkout;
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

always @(posedge clkout, negedge rst) begin
    if(!rst)
        scan_cnt <= 0;
    else begin
        if(scan_cnt==4'd8)
            scan_cnt <= 4'd1;
        else
            scan_cnt <= scan_cnt+1'b1;
    end
end
always @(scan_cnt) begin
    case (scan_cnt)
        4'd0: seg_en = 8'h00;
        4'd1: seg_en = 8'h01;
        4'd2: seg_en = 8'h02;
        4'd3: seg_en = 8'h04;
        4'd4: seg_en = 8'h08;
        4'd5: seg_en = 8'h10;
        4'd6: seg_en = 8'h20;
        4'd7: seg_en = 8'h40;
        4'd8: seg_en = 8'h80;
        default: seg_en = 8'h00;
    endcase
end
light_7seg_controller light_7seg_controller_u0(.radix(radix),.sw(scan_cnt),.seg_data(seg_data),.seg_out(seg_out0));
light_7seg_controller light_7seg_controller_u1(.radix(radix),.sw(scan_cnt),.seg_data(seg_data),.seg_out(seg_out1));
endmodule