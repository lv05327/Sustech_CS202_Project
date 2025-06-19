`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module leds (
    input led_rst,	// reset, active high
    input clk,	// clk of cpu
    input led_write,	// led write enable, active high
    input led_cs,	// 1 means the leds are selected as output
    input [31:0] led_data,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output reg [7:0] led_out    // the data writen to the leds of the board
);
    
    always @ (posedge clk, negedge led_rst) begin
        if (!led_rst)
            led_out <= 8'b0000_0000;
		else if (led_cs && led_write) begin
			led_out <= led_data[7:0];
        end
    end
endmodule
