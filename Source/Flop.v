`timescale 1ns/1ps
module CRegister(in, en, rst, clk, out);
    parameter N = 16;

    input [N-1:0] in;
    input en, clk, rst;

    output reg [N-1:0] out;

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= {N{1'b0}};
        else if (en)
            out <= in;
    end

endmodule