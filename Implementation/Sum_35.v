`timescale 1ns / 1ps

module Sum_51(A,B,sum);

input [50:0] A,B;
output [50:0] sum;
assign sum = A + B;

endmodule