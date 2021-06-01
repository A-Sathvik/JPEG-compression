`timescale 1ns / 1ps

module mul_Q(A,B,C); //12x23 Unsigned multiplier
input [22:0] A;
input [11:0] B;  // Always positive
output [34:0] C;
wire [34:0] PP[0:11];
assign PP[0] = {{12{1'b0}}, (A[22:0]) & {23{B[0]}}};
assign PP[1] = {{11{1'b0}}, (A[22:0]) & {23{B[1]}}, {1{1'b0}}};
assign PP[2] = {{10{1'b0}}, (A[22:0]) & {23{B[2]}}, {2{1'b0}}};
assign PP[3] = {{9{1'b0}}, (A[22:0]) & {23{B[3]}}, {3{1'b0}}};
assign PP[4] = {{8{1'b0}}, (A[22:0]) & {23{B[4]}}, {4{1'b0}}};
assign PP[5] = {{7{1'b0}}, (A[22:0]) & {23{B[5]}}, {5{1'b0}}};
assign PP[6] = {{6{1'b0}}, (A[22:0]) & {23{B[6]}}, {6{1'b0}}};
assign PP[7] = {{5{1'b0}}, (A[22:0]) & {23{B[7]}}, {7{1'b0}}};
assign PP[8] = {{4{1'b0}}, (A[22:0]) & {23{B[8]}}, {8{1'b0}}};
assign PP[9] = {{3{1'b0}}, (A[22:0]) & {23{B[9]}}, {9{1'b0}}};
assign PP[10] = {{2{1'b0}}, (A[22:0]) & {23{B[4'd10]}}, {10{1'b0}}};
assign PP[11] = {{1{1'b0}}, (A[22:0]) & {23{B[4'd11]}}, {11{1'b0}}};


wire [34:0]Acc[0:12];
assign Acc[0] = 35'd0;
genvar q;
generate
for (q=0; q<12; q = q+1) begin
    Sum_35 s1(Acc[q], PP[q], Acc[q+1]);
end
endgenerate
assign C = Acc[12];
endmodule