`timescale 1ns / 1ps

module Sum_28(A,B,sum);

input [27:0] A,B;
output [27:0] sum;
assign sum = A + B;

endmodule