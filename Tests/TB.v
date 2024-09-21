`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2024 19:48:07
// Design Name: 
// Module Name: TB
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


module TB();
    reg clk, rst;
    reg [5:0] User_in;
    wire[15:0] User_read;
    RISC_V risc_v(.clk(clk), .rst(rst), .User_in(User_in), .User_read(User_read));
    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        #2 rst = 1'b1;
        #6 rst = 1'b0;
        User_in = 16'd28;
        #100000 $stop;
    end
    
endmodule