`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/22 20:11:01
// Design Name: 
// Module Name: data_parser
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


module data_parser(
    input rst,
    input cs16, 
    input cs10,
    input [31:0] new_data,
    output reg [31:0] write_data,
    output reg [4:0] radix
);
    reg [31:0] data;
    always @(*) begin
        if (!rst) begin
            write_data = 0;
            radix = 0;
        end
        else begin
            if (cs10 | cs16) begin
                if (cs10&&~cs16) begin
                   data = new_data[31] ? ~(new_data - 1'b1) : new_data;
                   radix = 5'd10;
                end
                if (~cs10&&cs16) begin
                    data = new_data;
                    radix = 5'd16;
                end
                write_data[3:0] = data % radix;
                data = data / radix;
                write_data[7:4] = data % radix;
                data = data / radix;
                write_data[11:8] = data % radix;
                data = data / radix;
                write_data[15:12] = data % radix;
                data = data / radix;
                write_data[19:16] = data % radix;
                data = data / radix;
                write_data[23:20] = data % radix;
                data = data / radix;
                write_data[27:24] = data % radix;
                data = data / radix;
                write_data[31:28] = data % radix;
                data = data / radix;
                if (cs10&&~cs16) begin
                    write_data[31:28] = new_data[31] ? 4'b1111 : write_data[31:28];
                end
            end
            else begin
                write_data = write_data;
                radix = 0;
            end
        end
    end
endmodule
