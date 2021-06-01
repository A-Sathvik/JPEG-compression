`timescale 1ns / 1ps

module mul_20_8(A,signed_B,sign_A,C); // 20x8 Unsigned multiplier
input [19:0]A;  // Modulus value
input [7:0]signed_B;    // Signed value
input sign_A;
output [30:0] C;

wire [7:0] B; // Modulus of input B
assign B = signed_B[7] ? ~(signed_B)+1'b1 : signed_B;
wire [27:0] PP[0:7];
assign PP[0] = {{8{1'b0}}, A[19:0]&{20{B[0]}}};        //28 bits
assign PP[1] = {{7{1'b0}}, A[19:0]&{20{B[1]}}, {1{1'b0}}};
assign PP[2] = {{6{1'b0}}, A[19:0]&{20{B[2]}}, {2{1'b0}}};
assign PP[3] = {{5{1'b0}}, A[19:0]&{20{B[3]}}, {3{1'b0}}};
assign PP[4] = {{4{1'b0}}, A[19:0]&{20{B[4]}}, {4{1'b0}}};
assign PP[5] = {{3{1'b0}}, A[19:0]&{20{B[5]}}, {5{1'b0}}};
assign PP[6] = {{2{1'b0}}, A[19:0]&{20{B[6]}}, {6{1'b0}}};
assign PP[7] = {{1{1'b0}}, A[19:0]&{20{B[7]}}, {7{1'b0}}};

wire [27:0]Acc[0:8];
assign Acc[0] = 28'd0;
genvar q;
generate
for (q=0; q<8; q = q+1) begin
    Sum_28 s1(Acc[q], PP[q], Acc[q+1]);
end
endgenerate
assign C = (signed_B[7]^sign_A) ? {3'b111,~(Acc[8])+1'b1} : {3'b000,Acc[8]};
endmodule
