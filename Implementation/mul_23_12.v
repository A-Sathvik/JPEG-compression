`timescale 1ns / 1ps

module mul_31_20(signed_A,B,sign_B,C); //20x31 Unsigned multiplier
input [30:0]signed_A;
input [19:0]B;      // Modulus value
input sign_B;
output [53:0] C;
wire [30:0] A;      // Modulus value
assign A = signed_A[30] ? ~(signed_A)+1'b1 : signed_A;
wire [50:0] PP[0:19];
assign PP[0] = {{20{1'b0}}, (A[30:0]) & {30{B[0]}}};
assign PP[1] = {{19{1'b0}}, (A[30:0]) & {30{B[1]}}, {1{1'b0}}};
assign PP[2] = {{18{1'b0}}, (A[30:0]) & {30{B[2]}}, {2{1'b0}}};
assign PP[3] = {{17{1'b0}}, (A[30:0]) & {30{B[3]}}, {3{1'b0}}};
assign PP[4] = {{16{1'b0}}, (A[30:0]) & {30{B[4]}}, {4{1'b0}}};
assign PP[5] = {{15{1'b0}}, (A[30:0]) & {30{B[5]}}, {5{1'b0}}};
assign PP[6] = {{14{1'b0}}, (A[30:0]) & {30{B[6]}}, {6{1'b0}}};
assign PP[7] = {{13{1'b0}}, (A[30:0]) & {30{B[7]}}, {7{1'b0}}};
assign PP[8] = {{12{1'b0}}, (A[30:0]) & {30{B[8]}}, {8{1'b0}}};
assign PP[9] = {{11{1'b0}}, (A[30:0]) & {30{B[9]}}, {9{1'b0}}};
assign PP[10] = {{10{1'b0}}, (A[30:0]) & {30{B[10]}}, {10{1'b0}}};
assign PP[11] = {{9{1'b0}}, (A[30:0]) & {30{B[11]}}, {11{1'b0}}};
assign PP[12] = {{8{1'b0}}, (A[30:0]) & {30{B[12]}}, {12{1'b0}}};
assign PP[13] = {{7{1'b0}}, (A[30:0]) & {30{B[13]}}, {13{1'b0}}};
assign PP[14] = {{6{1'b0}}, (A[30:0]) & {30{B[14]}}, {14{1'b0}}};
assign PP[15] = {{5{1'b0}}, (A[30:0]) & {30{B[15]}}, {15{1'b0}}};
assign PP[16] = {{4{1'b0}}, (A[30:0]) & {30{B[16]}}, {16{1'b0}}};
assign PP[17] = {{3{1'b0}}, (A[30:0]) & {30{B[17]}}, {17{1'b0}}};
assign PP[18] = {{2{1'b0}}, (A[30:0]) & {30{B[18]}}, {18{1'b0}}};
assign PP[19] = {{1{1'b0}}, (A[30:0]) & {30{B[19]}}, {19{1'b0}}};


wire [50:0]Acc[0:20];
assign Acc[0] = 51'd0;
genvar q;
generate
for (q=0; q<20; q = q+1) begin
    Sum_51 s1(Acc[q], PP[q], Acc[q+1]);
end
endgenerate
assign C = (signed_A[30]^sign_B) ? {3'b111,~(Acc[20])+1'b1} : {3'b000,Acc[20]};
endmodule