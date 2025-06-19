`timescale 1ns / 1ps
module ioread (
    input clk,                // clk for CPU
    input reset,                // reset, active high
    input ior,                // from Controller, 1 means read from input device
    input switchCtrl1,            // means the switch1 is selected as input device
    input switchCtrl2,            // means the switch2 is selected as input device
    input [15:0] ioread_data_switch,    // the data from switch
    input enter,      
    output reg [7:0] ioread_data,         // the data to memorio
    output reg isIOReadOK
);
    wire pos;
    the_trigger u_trigger(
        .clk(clk),
        .trig(enter),
        .pos(pos)
    );
    always @( * ) begin
        if (!reset) begin
            ioread_data = 8'h0;
            isIOReadOK = 0;
        end
        else if (ior == 1) begin
            if (switchCtrl1 == 1 && pos == 1) begin
                ioread_data = ioread_data_switch[15:8];
                isIOReadOK = 1;
            end
            else if (switchCtrl2 == 1 && pos == 1)begin
                ioread_data = ioread_data_switch[7:0];
                isIOReadOK = 1;
            end
            else begin
                ioread_data = ioread_data;
                isIOReadOK = 0;
            end
        end
    end
endmodule