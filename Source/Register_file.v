//`define BITS(x) $rtoi($ceil($clog2(x)))
`timescale 1ns/1ps

module RegisterFile(clk, regWrite,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);
                    
    parameter WordLen = 16;
    parameter WordCount = 16;

    input regWrite, clk;
    input [2:0] readRegister1, readRegister2, writeRegister;
    input [WordLen-1:0] writeData;
    output [WordLen-1:0] readData1, readData2;
    integer i;

    reg [WordLen-1:0] registerFile [0:(WordCount /2)-1];
    
    initial begin
        for(i = 1; i <= 7; i = i + 1) begin
            registerFile[i] = 16'd0;
            end
        registerFile[0] = 16'h0; // Hardwaired zero.
         end

    always @(posedge clk) begin
        if (regWrite)
            registerFile[writeRegister] <= writeData;
    end

    assign readData1 = registerFile[readRegister1];
    assign readData2 = registerFile[readRegister2];

endmodule