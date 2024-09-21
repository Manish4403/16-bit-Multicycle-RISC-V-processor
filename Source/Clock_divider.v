`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2024 11:19:20
// Design Name: 
// Module Name: Clock_divider
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


module Clock_divider(clk, rst, clock_1hz);
    input clk, rst;
    output reg clock_1hz;
    reg [25:0]count;
    
    always@(posedge clk) begin
        if(rst) begin
            count <= 26'd0;
            clock_1hz <= 26'd0;
            end
        else if(count == 26'd0) begin
            clock_1hz <= ~clock_1hz;
            count <= 26'd0;
            end
        else
            count <= count + 26'd1;
    end
endmodule
