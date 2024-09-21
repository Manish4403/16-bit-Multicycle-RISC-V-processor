`define BEQ 2'b00
`define BNE 2'b01
`define BLT 2'b10

module BranchController(Branch_funct, branch, less_greater, zero, w);

    input branch, zero, less_greater;
    input [1:0] Branch_funct;

    output reg w;
    
    always @(Branch_funct, zero, less_greater, branch) begin
        case (Branch_funct)
            `BEQ   : w <= branch && zero;
            `BNE   : w <= branch && ~zero;
            `BLT   : w <= branch && less_greater;
            default: w <= 1'b0;
        endcase
    end

endmodule