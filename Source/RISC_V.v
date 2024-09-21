`timescale 1ns/1ps

module RISC_V(clk, rst, User_in, User_read);
    input clk, rst;
    input [5:0] User_in; //Used to index into data memory using FPGA.
    //*************************//
    
    //Clock Divider
//      Clock_divider Clock_divider(.clk(clk), .rst(rst), .clock_1hz(clk_50));
  
  //*******************************//
    
    wire [2:0] func3, ALUControl;
    wire[2:0] immSrc;
    
//    assign clk_in1 = clk;
//    assign reset = rst;
    
    //I/O pins
//    output[15:0] Result; //Used for implementation timing reports. from input clock to the result mux path.
    output [15:0] User_read; // Use to see the output of Data memory on FPGA.

    wire zero, less_greater, PCSrc, memWrite, 
         regWrite, ALUSrc, PCWrite, adrSrc, IRWrite, funct7;

    wire [1:0] resultSrc, ALUSrcA, ALUSrcB, Branch_funct;
    
    wire [2:0] op; 

    RISC_V_Controller CU(
        .clk(clk), .rst(rst), .op(op), 
        .func3(func3), .immSrc(immSrc), .zero(zero), 
        .less_greater(less_greater), .PCWrite(PCWrite),
        .adrSrc(adrSrc), .memWrite(memWrite), 
        .IRWrite(IRWrite), .resultSrc(resultSrc), 
        .ALUControl(ALUControl), .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB), .regWrite(regWrite),
        .Branch_funct(Branch_funct)
    );

    RISC_V_Datapath DP(
        .clk(clk), .rst(rst), .less_greater(less_greater),
        .PCWrite(PCWrite), .adrSrc(adrSrc),
        .memWrite(memWrite), .IRWrite(IRWrite), 
        .resultSrc(resultSrc), .immSrc(immSrc), 
        .ALUControl(ALUControl), .op(op),
        .ALUSrcA(ALUSrcA), .func3(func3),
        .ALUSrcB(ALUSrcB), .zero(zero),
        .regWrite(regWrite), .Branch_funct(Branch_funct), .funct7(funct7),
        .User_in(User_in), .User_read(User_read)
    );
    
endmodule