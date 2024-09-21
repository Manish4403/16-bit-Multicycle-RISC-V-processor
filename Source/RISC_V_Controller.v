`timescale 1ns/1ps

module RISC_V_Controller(clk, rst, op, func3, Branch_funct, zero,less_greater,
                    PCWrite, adrSrc, memWrite,
                    IRWrite, resultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, immSrc, regWrite);
    input [2:0] op;
    input [2:0] func3;
    input [1:0] Branch_funct;
    input clk, rst, zero, less_greater;
    
    output PCWrite, adrSrc, memWrite, IRWrite, regWrite;
    output [1:0] resultSrc, ALUSrcA, ALUSrcB;
    output [2:0] ALUControl;
    output [2:0] immSrc;
    
    wire PCUpdate, branch, Branch_out, jump;
    wire[1:0] ALUOp;

    MainController mainController(
        .clk(clk), .rst(rst), .op(op),
        .PCUpdate(PCUpdate),
        .adrSrc(adrSrc), .memWrite(memWrite),
        .branch(branch), .resultSrc(resultSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .immSrc(immSrc), .regWrite(regWrite),
        .IRWrite(IRWrite), .ALUOp(ALUOp), .jump(jump)
    );
    
    ALU_Controller ALUController(
        .func3(func3),  .ALUOp(ALUOp), .ALUControl(ALUControl), .Branch_funct(Branch_funct)
    );    
    
    BranchController Branch_Control(
                                    .Branch_funct(Branch_funct), .branch(branch), .less_greater(less_greater), .zero(zero), .w(Branch_out)
                                    );
                                         
    assign PCWrite = (PCUpdate | Branch_out | jump); 

endmodule