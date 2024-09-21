`timescale 1ns/1ps

//`define R_T     3'b000
//`define L_T     3'b001
//`define S_T     3'b010
//`define B_T     3'b011
//`define J_T     3'b100
//`define I_T     3'b101

`define Fetch        12'b000000000001 //0
`define Decode       12'b000000000010 //1
`define EX_L         12'b000000000100 // 2
`define EX_J         12'b000000001000 //5
`define EX_R         12'b000000010000 //3
`define RegWrite     12'b000000100000 //e
`define EX_B         12'b000001000000 // 4
`define EX_S         12'b000010000000 // 7
`define MemWrite     12'b000100000000 // c
`define MemRead      12'b001000000001 //b
`define MemWB        12'b010000000001 // 9
//`define RejWrite     12'b100000000000 // a
`define EX_I         12'b100000000001 //8

module MainController(clk, rst, op,
                      PCUpdate, adrSrc, memWrite, branch,
                      IRWrite, resultSrc, ALUOp, 
                      ALUSrcA, ALUSrcB, immSrc, regWrite, jump);

    input [2:0] op;
    input clk, rst;

    output reg [1:0]  resultSrc, ALUSrcA, ALUSrcB, ALUOp;
    output reg [2:0] immSrc;
    output reg adrSrc, regWrite, memWrite, PCUpdate, branch, IRWrite, jump;
    
    parameter [2:0] R_T = 3'b000, L_T = 3'b001,
                    S_T = 3'b010, B_T = 3'b011,
                    J_T = 3'b100, I_T = 3'b101;

    reg [11:0] pstate;
    reg [11:0] nstate;

    always @(*) begin
        case (pstate)
            `Fetch   : nstate = `Decode;

            `Decode  : nstate =  (op == L_T)    ? `EX_L     :
                                 (op == R_T)    ? `EX_R     :
                                 (op == B_T)    ? `EX_B     :                                   
                                 (op == J_T)    ? `EX_J     :
                                 (op == S_T)    ? `EX_S     : 
                                 (op == I_T)    ? `EX_I     :`Fetch;  // undefined instruction
                                 
                                 
            `EX_I : nstate = `RegWrite;
            `EX_L : nstate = `MemRead;
//            `RegWrite: nstate = `Fetch;

            `EX_R : nstate = `RegWrite;
            `RegWrite: nstate = `Fetch;

            `EX_B : nstate = `Fetch;

            `EX_J : nstate = `Fetch;
//            `RejWrite : nstate = `Fetch;

            `EX_S : nstate = `MemWrite;
            `MemWrite: nstate = `Fetch;
            
            `MemRead: nstate = `MemWB;
            `MemWB : nstate = `Fetch;
            
            default: nstate = `Fetch;
        endcase
    end

    always @(pstate) begin

        {resultSrc, memWrite, ALUOp, ALUSrcA, ALUSrcB, immSrc, 
                regWrite, PCUpdate, branch, IRWrite, jump, adrSrc} = 18'b0;

        case (pstate)
            // instruction fetch
            `Fetch : begin
                IRWrite   = 1'b1;
                adrSrc    = 1'b0;
                ALUSrcA   = 2'b00;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                resultSrc = 2'b10;
                PCUpdate  = 1'b1;
            end
            // instruction decode
            `Decode: begin
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b00;
                immSrc    = 3'b010;
            end
            //I-type
            `EX_I: begin 
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b01;
                immSrc    = 3'b100;
                ALUOp     = 2'b11;
            end
            // L-type
            `EX_L: begin 
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b01;
                immSrc    = 3'b000;
                ALUOp     = 2'b11;
            end

            `MemRead: begin
                resultSrc = 2'b00;
                adrSrc    = 1'b1;
            end

            `MemWB: begin
                resultSrc = 2'b01;
                regWrite  = 1'b1;
            end
            // R-type
            `EX_R: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b00;
                ALUOp     = 2'b10;
            end
            // B-type
            `EX_B: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b00;
                ALUOp     = 2'b01;
                resultSrc = 2'b00;
                branch    = 1'b1;
            end
            // J-type
            `EX_J: begin
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b00;
                resultSrc = 2'b10;
                immSrc    = 3'b011;
                jump      = 1'b1;
                
            end

            // S-type
            `EX_S: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b00;
                immSrc    = 3'b001;
            end
        
            `MemWrite: begin
                resultSrc = 2'b00;
                adrSrc    = 1'b1;
                memWrite  = 1'b1;
            end
            //ALUWB
            `RegWrite: begin
                resultSrc = 2'b00;
                regWrite  = 1'b1;
            end
//            `RejWrite: begin
//                resultSrc = 2'b00;
//                regWrite  = 1'b1;
//                PCUpdate  = 1'b1;

//            end
//            default: begin {resultSrc, memWrite, ALUOp, ALUSrcA, ALUSrcB, immSrc, 
//                regWrite, PCUpdate, branch, IRWrite, jump, adrSrc} = 18'b0; end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            pstate <= `Fetch;
        else
            pstate <= nstate;
    end

endmodule