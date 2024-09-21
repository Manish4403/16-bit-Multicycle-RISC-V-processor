`timescale 1ns/1ps

//`define L_T 3'b000
//`ifndef S_T 3'b001
//`define B_T 3'b010
//`define J_T 3'b011
//`define I_T 3'b100

module ImmExtension(immSrc, data, w);

    input [2:0] immSrc;
    input [12:0] data;
    
    parameter [2:0] L_T = 3'b000, S_T = 3'b001,
                    B_T = 3'b010, J_T = 3'b011,
                    I_T = 3'b100;
    
    output reg [15:0] w;

    always @(immSrc, data) begin
        case (immSrc)
            L_T   : w <= {{9{data[12]}},data[12], data[8:6] , data[2:0]};
            S_T   : w <= {{19{data[12]}},data[12], data[5:0]};
            J_T   : w <= {{3{data[12]}},data[12], data[11:0]};
            B_T   : w <= {{11{data[12]}}, data[12], data[9], data[2:0]};
            I_T   : w <= {{9{data[12]}},data[12], data[8:6], data[2:0]};
            default: w <= 16'dx;
        endcase
    end

endmodule