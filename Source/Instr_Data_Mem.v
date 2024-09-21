`timescale 1ns/1ps

module Memory(clk , memWrite, memAdr, writeData, readData, User_in_check, User_readData);
  //inputs
  input clk,  memWrite;
  input [15:0] writeData; 
  input [5:0] memAdr;
  input [5:0] User_in_check;
  //outputs    
  output [15:0] readData;
  output [15:0] User_readData;
  //memory declarations
  reg [15:0] memData[0:50];

  
  integer i;
  initial begin
    for(i = 1; i <= 50 ; i = i+2) begin
      memData[i] = i; 
      end
     // $readmemb( "Memory.txt" ,memData,0 ,$pow(2, 4)-1 ); 
     //Storing Instruction. 
     memData[0] =  16'h52c6; // addi
     memData[2] = 16'h1408; // Load
     memData[4] = 16'h5641; // addi
     memData[6] = 16'h520a; // find_max addi
     memData[8] = 16'h1808;  //load
     memData[10] = 16'h3914; // branch (BTA = oldPC(PC of prev instruction) + current offset) blt to update_max
     memData[12] = 16'h4004;  // Jump to continue_loop
     memData[14] = 16'h5420; // update_max addi
     memData[16] = 16'hd7df; // continue_loop addi -1
     memData[18] = 16'hB4c4; // Bne to find_max.
     memData[20] = 16'h0a10; // R-type add the max value to a register .
     memData[22] = 16'h2c9c; // Store the max value
     memData[24] = 16'h4000; // Jump to itself.
     
     
     memData[26] = 16'd0;
     memData[28] = 16'd0;
     //**********************************//
     //Storing data here.
     memData[30] = 16'd3;
     memData[32] = 16'd1;
     memData[34] = 16'd7;
     memData[36] = 16'd2;
     memData[38] = 16'd9;
     memData[40] = 16'd5;
     memData[42] = 16'd8;
     memData[44] = 16'd6;
     memData[46] = 16'd4;
     memData[48] = 16'd0;
  end


  always @(posedge clk)
    begin
          if (memWrite == 1 ) begin
              memData[memAdr] = writeData;  // Storing 1 byte at a time byteaddressable memory. // First word at location 0.
	end          
    end

  assign readData = memData[memAdr]; //Reading the whole word.
  assign User_readData = memData[User_in_check];
  

endmodule





