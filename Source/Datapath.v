`timescale 1ns/1ps

module RISC_V_Datapath(clk, rst, PCWrite, adrSrc, memWrite,
                    IRWrite, resultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, immSrc, regWrite,
                    op, func3, Branch_funct, zero, less_greater, funct7,
                    User_in, User_read);

    input clk, rst, PCWrite, adrSrc, memWrite, IRWrite, regWrite;
    input [1:0] resultSrc, ALUSrcA, ALUSrcB;
    input [2:0] ALUControl;
    input [2:0] immSrc;
    input [5:0] User_in;
    output[15:0] User_read;
    
    output [2:0] op;
    output [2:0] func3;
    output [1:0] Branch_funct;
    output  zero, less_greater, funct7;
    
    
    
    
    wire [15:0] Adr, PC, ReadData, OldPC;
    wire [15:0] ImmExt, instr, Data;
    wire [15:0] RD1, RD2, A, B, SrcA, SrcB;
    wire [15:0] ALUResult, ALUOut, Result;

    CRegister  PCR  (.in(Result),    .en(PCWrite), .rst(rst), .clk(clk), .out(PC));
    CRegister OldPCR(.in(PC),        .en(IRWrite), .rst(rst), .clk(clk), .out(OldPC));
    CRegister  IR   (.in(ReadData),  .en(IRWrite), .rst(rst), .clk(clk), .out(instr));
    CRegister MDR   (.in(ReadData),  .en(1'b1),    .rst(rst), .clk(clk), .out(Data));
    CRegister AR    (.in(RD1),       .en(1'b1),    .rst(rst), .clk(clk), .out(A));
    CRegister BR    (.in(RD2),       .en(1'b1),    .rst(rst), .clk(clk), .out(B));
    CRegister ALUR  (.in(ALUResult), .en(1'b1),    .rst(rst), .clk(clk), .out(ALUOut));

    Mux2to1 AdrMux(.slc(adrSrc),    .a(PC),     .b(Result), .w(Adr));

    Mux4to1 AMux     (.slc(ALUSrcA),   .a(PC),     .b(OldPC),  .c(A),         .d(16'd0),  .w(SrcA));
    Mux4to1 BMux     (.slc(ALUSrcB),   .a(B),      .b(ImmExt), .c(16'd2),     .d(16'd0),  .w(SrcB));
    Mux4to1 ResultMux(.slc(resultSrc), .a(ALUOut), .b(Data),   .c(ALUResult), .d(ImmExt), .w(Result));

    ImmExtension Extend(
        .immSrc(immSrc), .data({instr[15], instr[11:0]}), .w(ImmExt)
    );

    ALU ALU_Instance(
        .ALUControl(ALUControl), .a(SrcA), .b(SrcB), 
        .zero(zero), .less_greater(less_greater), .w(ALUResult)
    );

    Memory DM(
        .memAdr(Adr[5:0]), .writeData(B), .clk(clk), 
        .memWrite(memWrite), .readData(ReadData),
        .User_in_check(User_in), .User_readData(User_read)
    );

    RegisterFile RF(
        .clk(clk), 
        .regWrite(regWrite),
        .writeData(Result), 
        .readData1(RD1), .readData2(RD2),
        .readRegister1(instr[5:3]), 
        .readRegister2(instr[8:6]),
        .writeRegister(instr[11:9])
    );
    
    assign funct7 = instr[15]; 
    assign op = instr[14:12];
    assign func3 = instr[2:0];
    assign Branch_funct = instr[11:10];
endmodule