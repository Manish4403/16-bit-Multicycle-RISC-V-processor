`timescale 1ns/1ps

`define S_T   2'b00
`define B_T   2'b01
`define R_T   2'b10
`define I_T   2'b11


`define ADD  3'b000
`define SUB  3'b001
`define AND  3'b010
`define OR   3'b011
`define SLT  3'b101
`define XOR  3'b100

`define beq 2'b00
`define bne 2'b01
`define blt 2'b10


module ALU_Controller(func3, Branch_funct, ALUOp, ALUControl);

    input [2:0] func3;
    input [1:0] Branch_funct;
    input [1:0] ALUOp; //bit 30 instr

    output reg [2:0] ALUControl;
    
    always @(ALUOp or func3 or Branch_funct)begin
        case (ALUOp)
            `S_T   : ALUControl <= `ADD;
            `B_T   : ALUControl <= 
                        (Branch_funct == `beq) ? `SUB:
                        (Branch_funct == `bne) ? `SUB:
                        (Branch_funct == `blt) ? `SLT: 3'bzzz;
            `R_T   : ALUControl <= 
                        (func3 == 3'b000) ? `ADD:
                        (func3 == 3'b001)  ? `SUB:
                        (func3 == 3'b111) ? `AND:
                        (func3 == 3'b110) ? `OR:
                        (func3 == 3'b010) ? `SLT : 3'bzzz;
            `I_T   : ALUControl <= `ADD;
            default: ALUControl <= `ADD;
        endcase
    end
endmodule