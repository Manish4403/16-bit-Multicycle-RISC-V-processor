`timescale 1ns/1ps

`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR  3'b011
`define SLT 3'b101
`define XOR 3'b100

module ALU(ALUControl, a, b, zero, less_greater, w);
    parameter N = 16;

    input [2:0] ALUControl;
    input signed [N-1:0] a, b;
    
    output zero, less_greater;
    output reg signed [N-1:0] w;
    
    always @(a or b or ALUControl) begin
        case (ALUControl)
            `ADD   :  w = a + b;
            `SUB   :  w = a - b;
            `AND   :  w = a & b;
            `OR    :  w = a | b;
            `SLT   :  w = $signed(a) < $signed(b) ? 16'd1 : 16'd0;
            `XOR   :  w = a ^ b;
            default:  w = {N{1'bz}};
        endcase
    end

    assign zero = (~|w);
    assign less_greater = |w;

endmodule