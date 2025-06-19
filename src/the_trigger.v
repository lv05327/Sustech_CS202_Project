`timescale 1ns / 1ps
module the_trigger(
    input clk,trig,
    output pos
);
    reg trig1=1'b0,trig2=1'b0;
    wire trig_edge;
    always @(posedge clk) begin
        trig1 <= trig;
        trig2 <= trig1;
    end
    assign trig_edge = (~trig2) & trig1;
    reg [9:0] cnt1=10'd0;
    reg [10:0] cnt2=11'd0;
    reg trig3=1'b0,trig4=1'b0;
    always @(posedge clk) begin
        if (trig_edge) begin
            cnt1 <= 10'd0;
            cnt2 <= 11'd0;
            trig3 <= 1'b0;
            trig4 <= 1'b0;
        end
        else begin
            if (cnt1==10'd1000&&cnt2!=11'd400) begin
                cnt2 <= cnt2 + 1'd1;
                cnt1 <= 10'd0;
            end
            else cnt1 <= cnt1 + 1'd1;
        end
        if (cnt2 == 11'd200) trig3 <= trig;
        trig4 <= trig3;
    end
    assign pos = trig3 & (~trig4);
endmodule
