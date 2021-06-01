`timescale 1ns / 1ps

module Sum_35(A,B,sum);

input [34:0] A,B;
output [34:0] sum;
assign sum = A + B;

endmodule