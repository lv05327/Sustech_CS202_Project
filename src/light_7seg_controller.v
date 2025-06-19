`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 03:15:50
// Design Name: 
// Module Name: light_7seg_controller
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


module light_7seg_controller(
    input [4:0] radix,
    input [3:0] sw,
    input [31:0] seg_data,
    output reg [7:0] seg_out
    );
    
    reg [7:0] led[0:7];
    
    always @ (*) begin
        case(sw)
            4'd0: seg_out = 8'b1111_1100;
            4'd1: seg_out = led[0];
            4'd2: seg_out = led[1];
            4'd3: seg_out = led[2];
            4'd4: seg_out = led[3];
            4'd5: seg_out = led[4];
            4'd6: seg_out = led[5];
            4'd7: seg_out = led[6];
            4'd8: seg_out = led[7];
        endcase
    end
    always @ (*) begin
        case(seg_data[3:0])
            4'h0: led[0] = 8'b1111_1100;
            4'h1: led[0] = 8'b0110_0000;
            4'h2: led[0] = 8'b1101_1010;
            4'h3: led[0] = 8'b1111_0010;
            4'h4: led[0] = 8'b0110_0110;
            4'h5: led[0] = 8'b1011_0110;
            4'h6: led[0] = 8'b1011_1110;
            4'h7: led[0] = 8'b1110_0000;
            4'h8: led[0] = 8'b1111_1110;
            4'h9: led[0] = 8'b1111_0110;
            4'ha: led[0] = 8'b1110_1110;
            4'hb: led[0] = 8'b0011_1110;
            4'hc: led[0] = 8'b0001_1010;
            4'hd: led[0] = 8'b0111_1010;
            4'he: led[0] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[0] = 8'b1000_1110;
                if (radix == 5'd10) led[0] = 8'b0000_0010;
            end
            default: led[0] = 8'b1111111;
        endcase
        case(seg_data[7:4])
            4'h0: led[1] = 8'b1111_1100;
            4'h1: led[1] = 8'b0110_0000;
            4'h2: led[1] = 8'b1101_1010;
            4'h3: led[1] = 8'b1111_0010;
            4'h4: led[1] = 8'b0110_0110;
            4'h5: led[1] = 8'b1011_0110;
            4'h6: led[1] = 8'b1011_1110;
            4'h7: led[1] = 8'b1110_0000;
            4'h8: led[1] = 8'b1111_1110;
            4'h9: led[1] = 8'b1111_0110;
            4'ha: led[1] = 8'b1110_1110;
            4'hb: led[1] = 8'b0011_1110;
            4'hc: led[1] = 8'b0001_1010;
            4'hd: led[1] = 8'b0111_1010;
            4'he: led[1] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[1] = 8'b1000_1110;
                if (radix == 5'd10) led[1] = 8'b0000_0010;
            end
            default: led[1] = 8'b1111111;
        endcase
        case(seg_data[11:8])
            4'h0: led[2] = 8'b1111_1100;
            4'h1: led[2] = 8'b0110_0000;
            4'h2: led[2] = 8'b1101_1010;
            4'h3: led[2] = 8'b1111_0010;
            4'h4: led[2] = 8'b0110_0110;
            4'h5: led[2] = 8'b1011_0110;
            4'h6: led[2] = 8'b1011_1110;
            4'h7: led[2] = 8'b1110_0000;
            4'h8: led[2] = 8'b1111_1110;
            4'h9: led[2] = 8'b1111_0110;
            4'ha: led[2] = 8'b1110_1110;
            4'hb: led[2] = 8'b0011_1110;
            4'hc: led[2] = 8'b0001_1010;
            4'hd: led[2] = 8'b0111_1010;
            4'he: led[2] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[2] = 8'b1000_1110;
                if (radix == 5'd10) led[2] = 8'b0000_0010;
            end
            default: led[2] = 8'b1111111;
        endcase
        case(seg_data[15:12])
            4'h0: led[3] = 8'b1111_1100;
            4'h1: led[3] = 8'b0110_0000;
            4'h2: led[3] = 8'b1101_1010;
            4'h3: led[3] = 8'b1111_0010;
            4'h4: led[3] = 8'b0110_0110;
            4'h5: led[3] = 8'b1011_0110;
            4'h6: led[3] = 8'b1011_1110;
            4'h7: led[3] = 8'b1110_0000;
            4'h8: led[3] = 8'b1111_1110;
            4'h9: led[3] = 8'b1111_0110;
            4'ha: led[3] = 8'b1110_1110;
            4'hb: led[3] = 8'b0011_1110;
            4'hc: led[3] = 8'b0001_1010;
            4'hd: led[3] = 8'b0111_1010;
            4'he: led[3] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[3] = 8'b1000_1110;
                if (radix == 5'd10) led[3] = 8'b0000_0010;
            end
            default: led[3] = 8'b1111111;
        endcase
        case(seg_data[19:16])
            4'h0: led[4] = 8'b1111_1100;
            4'h1: led[4] = 8'b0110_0000;
            4'h2: led[4] = 8'b1101_1010;
            4'h3: led[4] = 8'b1111_0010;
            4'h4: led[4] = 8'b0110_0110;
            4'h5: led[4] = 8'b1011_0110;
            4'h6: led[4] = 8'b1011_1110;
            4'h7: led[4] = 8'b1110_0000;
            4'h8: led[4] = 8'b1111_1110;
            4'h9: led[4] = 8'b1111_0110;
            4'ha: led[4] = 8'b1110_1110;
            4'hb: led[4] = 8'b0011_1110;
            4'hc: led[4] = 8'b0001_1010;
            4'hd: led[4] = 8'b0111_1010;
            4'he: led[4] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[4] = 8'b1000_1110;
                if (radix == 5'd10) led[4] = 8'b0000_0010;
            end
            default: led[4] = 8'b1111111;
        endcase
        case(seg_data[23:20])
            4'h0: led[5] = 8'b1111_1100;
            4'h1: led[5] = 8'b0110_0000;
            4'h2: led[5] = 8'b1101_1010;
            4'h3: led[5] = 8'b1111_0010;
            4'h4: led[5] = 8'b0110_0110;
            4'h5: led[5] = 8'b1011_0110;
            4'h6: led[5] = 8'b1011_1110;
            4'h7: led[5] = 8'b1110_0000;
            4'h8: led[5] = 8'b1111_1110;
            4'h9: led[5] = 8'b1111_0110;
            4'ha: led[5] = 8'b1110_1110;
            4'hb: led[5] = 8'b0011_1110;
            4'hc: led[5] = 8'b0001_1010;
            4'hd: led[5] = 8'b0111_1010;
            4'he: led[5] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[5] = 8'b1000_1110;
                if (radix == 5'd10) led[5] = 8'b0000_0010;
            end
            default: led[5] = 8'b1111111;
        endcase
        case(seg_data[27:24])
            4'h0: led[6] = 8'b1111_1100;
            4'h1: led[6] = 8'b0110_0000;
            4'h2: led[6] = 8'b1101_1010;
            4'h3: led[6] = 8'b1111_0010;
            4'h4: led[6] = 8'b0110_0110;
            4'h5: led[6] = 8'b1011_0110;
            4'h6: led[6] = 8'b1011_1110;
            4'h7: led[6] = 8'b1110_0000;
            4'h8: led[6] = 8'b1111_1110;
            4'h9: led[6] = 8'b1111_0110;
            4'ha: led[6] = 8'b1110_1110;
            4'hb: led[6] = 8'b0011_1110;
            4'hc: led[6] = 8'b0001_1010;
            4'hd: led[6] = 8'b0111_1010;
            4'he: led[6] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[6] = 8'b1000_1110;
                if (radix == 5'd10) led[6] = 8'b0000_0010;
            end
            default: led[6] = 8'b1111111;
        endcase
        case(seg_data[31:28])
            4'h0: led[7] = 8'b1111_1100;
            4'h1: led[7] = 8'b0110_0000;
            4'h2: led[7] = 8'b1101_1010;
            4'h3: led[7] = 8'b1111_0010;
            4'h4: led[7] = 8'b0110_0110;
            4'h5: led[7] = 8'b1011_0110;
            4'h6: led[7] = 8'b1011_1110;
            4'h7: led[7] = 8'b1110_0000;
            4'h8: led[7] = 8'b1111_1110;
            4'h9: led[7] = 8'b1111_0110;
            4'ha: led[7] = 8'b1110_1110;
            4'hb: led[7] = 8'b0011_1110;
            4'hc: led[7] = 8'b0001_1010;
            4'hd: led[7] = 8'b0111_1010;
            4'he: led[7] = 8'b1001_1110;
            4'hf: begin
                if (radix == 5'd16) led[7] = 8'b1000_1110;
                if (radix == 5'd10) led[7] = 8'b0000_0010;
            end
            default: led[7] = 8'b1111111;
        endcase
    end
endmodule
