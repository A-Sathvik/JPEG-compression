`timescale 1ns / 1ps
//OM
module DCT_2D(I, rst, clk, enable, prev_dc_value, start_MCU, ready, Output, done, present_dc_value, first_MCU, Valid_output);
input [7:0]I;   // Input Y / Cb / Cr value supplied sequetially, row-wise (8-bit input intensities) 
input clk, rst, enable, first_MCU, start_MCU;
input [0:13] prev_dc_value;
output [0:22] Output; //Huffman coded, final sequential output
output reg ready;
output reg done;
output [0:13] present_dc_value;
output reg Valid_output;
// Aim: To compute T*M*T', each is an 8x8 matrix
// T is given and values of Message matrix (M) enter (row-wise) through I with clock.
/*
 Here, given matrix T is referred as A. Each element of A are cosine values (-0.5,0.5)
 We store only the mantissa (20-bit precision) in A
 The sign is stored in  signA matrix (0 for positive values, 1 for negative values)
 Note: A, SignA are fixed matrices for DCT-2D operation
*/
wire [19:0]A[0:63];         // DCT matrix (fixed)
reg [6:0]ctr;               // To keep track of input value's position
wire signA[0:63];           // Signs of the DCT matrix

/*
We start with calculating M.T', i.e., Message.A'

We store each partial product (PP) in Accumulator (Acc = M.T' finally)
Size of each PP = 20 x 8 = 28 bits
Size of each element of 8x8 matrix Acc is 28 + log 8 base 2 = 31 bits
*/
wire [30:0]PP[0:7]; // 3 extra bits for sign-extension
reg [30:0]Acc[0:63];
/*
Calculating M*T' alone requires 64 clock cycles.
So in the mean time, after extracting each complete row of Acc (= M*T'), 
we start computing T*M*T' parallely.
To reuse the same matrix T,the elements of T are accessed ina a slightly opposite sense such that M*T' is obtained.

Now the partial products PP2 are of size 20 x 31 = 51 bits
and are stored in Acc2 of 51 + log 8 ( = 54 bits)
*/
wire [53:0]PP2[0:7];
reg [53:0]Acc2[0:63];   // Final result (DCT Coefficients)

reg [3:0] Acc_ctr, Acc2_ctr, Input_turns;
reg [6:0] changed_ctr, acc_loc_ctr;
reg Acc_en, Acc_done, latch;
wire [0:34] Quantised_0, Quantised_1, Quantised_2, Quantised_3, Quantised_4, Quantised_5, Quantised_6, Quantised_7; //
reg [0:13]After_Q[0:63];   // Final result (Quantised)

wire [30:0]Acc3;     // Same as size of Acc
// The operation completes in 72 clock cycles
reg DCT_done, Quantisation_done;
wire[0:13] After_ZZ[0:63];
wire [0:1151] After_RL;
reg [0:11]RL [0:63];
reg [0:11] RL_present;
reg stop_RLE;
reg [0:5] i,j,index;
reg [0:13] in1,in2;

reg [6:0] ctr_h;
reg dc_h,dc_down;
wire [7:0] value_h;
wire [3:0] run_h;
wire [2:0] Size_h;
wire [6:0] Suffix_code;
wire [0:22] After_H;
reg [6:0] last_non_zeroes_RL, zeroes_RL;
reg [6:0] last_non_zero_terms_RL, zero_terms_RL;
reg final_term_H;

assign {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], 
        A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15], 
        A[16], A[17], A[18], A[19], A[20], A[21], A[22], A[23], 
        A[24], A[25], A[26], A[27], A[28], A[29], A[30], A[31], 
        A[32], A[33], A[34], A[35], A[36], A[37], A[38], A[39], 
        A[40], A[41], A[42], A[43], A[44], A[45], A[46], A[47], 
        A[48], A[49], A[50], A[51], A[52], A[53], A[54], A[55], 
        A[56], A[57], A[58], A[59], A[60], A[61], A[62], A[63]}
      = {20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 
         20'b0111_1101_1000_1010_1101, 20'b0110_1010_0110_1011_0101, 20'b0100_0111_0001_1101_1110, 20'b0001_1000_1111_0101_1100, 20'b0001_1000_1111_0101_1100, 20'b0100_0111_0001_1101_1110, 20'b0110_1010_0110_1011_0101, 20'b0111_1101_1000_1010_1101, 
         20'b0111_0110_0011_1111_0001, 20'b0011_0000_1111_1001_0000, 20'b0011_0000_1111_1001_0000, 20'b0111_0110_0011_1111_0001, 20'b0111_0110_0011_1111_0001, 20'b0011_0000_1111_1001_0000, 20'b0011_0000_1111_1001_0000, 20'b0111_0110_0011_1111_0001, 
         20'b0110_1010_0110_1011_0101, 20'b0001_1000_1111_0101_1100, 20'b0111_1101_1000_1010_1101, 20'b0100_0111_0001_1101_1110, 20'b0100_0111_0001_1101_1110, 20'b0111_1101_1000_1010_1101, 20'b0001_1000_1111_0101_1100, 20'b0110_1010_0110_1011_0101, 
         20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 20'b0101_1010_1000_0101_1000, 
         20'b0100_0111_0001_1101_1110, 20'b0111_1101_1000_1010_1101, 20'b0001_1000_1111_0101_1100, 20'b0110_1010_0110_1011_0101, 20'b0110_1010_0110_1011_0101, 20'b0001_1000_1111_0101_1100, 20'b0111_1101_1000_1010_1101, 20'b0100_0111_0001_1101_1110, 
         20'b0011_0000_1111_1001_0000, 20'b0111_0110_0011_1111_0001, 20'b0111_0110_0011_1111_0001, 20'b0011_0000_1111_1001_0000, 20'b0011_0000_1111_1001_0000, 20'b0111_0110_0011_1111_0001, 20'b0111_0110_0011_1111_0001, 20'b0011_0000_1111_1001_0000, 
         20'b0001_1000_1111_0101_1100, 20'b0100_0111_0001_1101_1110, 20'b0110_1010_0110_1011_0101, 20'b0111_1101_1000_1010_1101, 20'b0111_1101_1000_1010_1101, 20'b0110_1010_0110_1011_0101, 20'b0100_0111_0001_1101_1110, 20'b0001_1000_1111_0101_1100};

//      {12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 
//        12'b011111011000, 12'b011010100110, 12'b010001110001, 12'b000110001111, 12'b000110001111, 12'b010001110001, 12'b011010100110, 12'b011111011000,
//        12'b011101100011, 12'b001100001111, 12'b001100001111, 12'b011101100011, 12'b011101100011, 12'b001100001111, 12'b001100001111, 12'b011101100011,
//        12'b011010100110, 12'b000110001111, 12'b011111011000, 12'b010001110001, 12'b010001110001, 12'b011111011000, 12'b000110001111, 12'b011010100110,
//        12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000, 12'b010110101000,
//        12'b010001110001, 12'b011111011000, 12'b000110001111, 12'b011010100110, 12'b011010100110, 12'b000110001111, 12'b011111011000, 12'b010001110001,
//        12'b001100001111, 12'b011101100011, 12'b011101100011, 12'b001100001111, 12'b001100001111, 12'b011101100011, 12'b011101100011, 12'b001100001111,
//        12'b000110001111, 12'b010001110001, 12'b011010100110, 12'b011111011000, 12'b011111011000, 12'b011010100110, 12'b010001110001, 12'b000110001111};   // DCT table

assign {signA[0], signA[1], signA[2], signA[3], signA[4], signA[5], signA[6], signA[7], 
                signA[8], signA[9], signA[10], signA[11], signA[12], signA[13], signA[14], signA[15], 
                signA[16], signA[17], signA[18], signA[19], signA[20], signA[21], signA[22], signA[23], 
                signA[24], signA[25], signA[26], signA[27], signA[28], signA[29], signA[30], signA[31], 
                signA[32], signA[33], signA[34], signA[35], signA[36], signA[37], signA[38], signA[39], 
                signA[40], signA[41], signA[42], signA[43], signA[44], signA[45], signA[46], signA[47], 
                signA[48], signA[49], signA[50], signA[51], signA[52], signA[53], signA[54], signA[55], 
                signA[56], signA[57], signA[58], signA[59], signA[60], signA[61], signA[62], signA[63]}
                 = 64'b0000_0000_0000_1111_0011_1100_0111_0001_0110_0110_0100_1101_0101_1010_0101_0101;
                                                                                                                   
wire [0:11]Q [0:63];                                                                                                                 
assign {Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7], 
        Q[8], Q[9], Q[10], Q[11], Q[12], Q[13], Q[14], Q[15], 
        Q[16], Q[17], Q[18], Q[19], Q[20], Q[21], Q[22], Q[23], 
        Q[24], Q[25], Q[26], Q[27], Q[28], Q[29], Q[30], Q[31], 
        Q[32], Q[33], Q[34], Q[35], Q[36], Q[37], Q[38], Q[39], 
        Q[40], Q[41], Q[42], Q[43], Q[44], Q[45], Q[46], Q[47], 
        Q[48], Q[49], Q[50], Q[51], Q[52], Q[53], Q[54], Q[55], 
        Q[56], Q[57], Q[58], Q[59], Q[60], Q[61], Q[62], Q[63]}
         = {12'b000100000000, 12'b000101110100, 12'b000110011001, 12'b000100000000, 12'b000010101010, 12'b000001100110, 12'b000001010000, 12'b000001000011, 
            12'b000101010101, 12'b000101010101, 12'b000100100100, 12'b000011010111, 12'b000010011101, 12'b000001000110, 12'b000001000100, 12'b000001001010, 
            12'b000100100100, 12'b000100111011, 12'b000100000000, 12'b000010101010, 12'b000001100110, 12'b000001000111, 12'b000000111011, 12'b000001001001, 
            12'b000100100100, 12'b000011110000, 12'b000010111010, 12'b000010001101, 12'b000001010000, 12'b000000101111, 12'b000000110011, 12'b000001000010, 
            12'b000011100011, 12'b000010111010, 12'b000001101110, 12'b000001001001, 12'b000000111100, 12'b000000100101, 12'b000000100111, 12'b000000110101, 
            12'b000010101010, 12'b000001110101, 12'b000001001010, 12'b000001000000, 12'b000000110010, 12'b000000100111, 12'b000000100100, 12'b000000101100, 
            12'b000001010011, 12'b000001000000, 12'b000000110100, 12'b000000101111, 12'b000000100111, 12'b000000100001, 12'b000000100010, 12'b000000101000, 
            12'b000000111000, 12'b000000101100, 12'b000000101011, 12'b000000101001, 12'b000000100100, 12'b000000101000, 12'b000000100111, 12'b000000101001};



/* 
ctr is of 7 bits, 
4-MSBits represent row value
3-LSBits represent column value of the incoming pixel value
*/
// As we proceed in 64 size array MCU, we should keep track of actual row and column elements.
wire [5:0]m1A[0:7];                 // Gathers present row-cells in matrix A
assign m1A[0] = {3'd0, ctr[2:0]};
assign m1A[1] = {3'd1, ctr[2:0]};
assign m1A[2] = {3'd2, ctr[2:0]};
assign m1A[3] = {3'd3, ctr[2:0]};
assign m1A[4] = {3'd4, ctr[2:0]};
assign m1A[5] = {3'd5, ctr[2:0]};
assign m1A[6] = {3'd6, ctr[2:0]};
assign m1A[7] = {3'd7, ctr[2:0]};

mul_20_8 m0(A[m1A[0]],I,signA[m1A[0]],PP[0]);	// M*T' is performed element-wise 
mul_20_8 m1(A[m1A[1]],I,signA[m1A[1]],PP[1]);
mul_20_8 m2(A[m1A[2]],I,signA[m1A[2]],PP[2]);
mul_20_8 m3(A[m1A[3]],I,signA[m1A[3]],PP[3]);
mul_20_8 m4(A[m1A[4]],I,signA[m1A[4]],PP[4]);
mul_20_8 m5(A[m1A[5]],I,signA[m1A[5]],PP[5]);
mul_20_8 m6(A[m1A[6]],I,signA[m1A[6]],PP[6]);
mul_20_8 m7(A[m1A[7]],I,signA[m1A[7]],PP[7]);	// These PartialProducts are to be placed correctly in Acc



wire [5:0]m2A[0:7];         // Column values remaining same for 8 cycles, for T.M.T'
wire [5:0]ctr2;
//assign ctr2 = ctr[6:3]-6'd1;
assign ctr2 = Input_turns[2:0] - 6'd1;
assign m2A[0] = {3'd0, ctr2[2:0]};
assign m2A[1] = {3'd1, ctr2[2:0]};
assign m2A[2] = {3'd2, ctr2[2:0]};
assign m2A[3] = {3'd3, ctr2[2:0]};
assign m2A[4] = {3'd4, ctr2[2:0]};
assign m2A[5] = {3'd5, ctr2[2:0]};
assign m2A[6] = {3'd6, ctr2[2:0]};
assign m2A[7] = {3'd7, ctr2[2:0]};

wire [5:0]acc_loc;                          // To access M.T' values
//assign acc_loc = {ctr2[2:0], ctr[2:0]};
//assign acc_loc = {changed_ctr[6:3] - 6'd1, changed_ctr[2:0]};
//assign acc_loc = {Acc2_ctr[6:3] - 6'd1, Acc2_ctr[2:0]};
assign acc_loc = acc_loc_ctr[5:0];
assign Acc3= Acc[acc_loc];

mul_31_20 m20(.B(A[m2A[0]]),.sign_B(signA[m2A[0]]),.signed_A(Acc3),.C(PP2[0]));    //
mul_31_20 m21(.B(A[m2A[1]]),.sign_B(signA[m2A[1]]),.signed_A(Acc3),.C(PP2[1]));
mul_31_20 m22(.B(A[m2A[2]]),.sign_B(signA[m2A[2]]),.signed_A(Acc3),.C(PP2[2]));
mul_31_20 m23(.B(A[m2A[3]]),.sign_B(signA[m2A[3]]),.signed_A(Acc3),.C(PP2[3]));
mul_31_20 m24(.B(A[m2A[4]]),.sign_B(signA[m2A[4]]),.signed_A(Acc3),.C(PP2[4]));
mul_31_20 m25(.B(A[m2A[5]]),.sign_B(signA[m2A[5]]),.signed_A(Acc3),.C(PP2[5]));
mul_31_20 m26(.B(A[m2A[6]]),.sign_B(signA[m2A[6]]),.signed_A(Acc3),.C(PP2[6]));
mul_31_20 m27(.B(A[m2A[7]]),.sign_B(signA[m2A[7]]),.signed_A(Acc3),.C(PP2[7]));

wire [5:0]acc1_loc[0:7];                        // To specify M.T' partial products location
//assign acc1_loc[0]= {ctr[5:3], 3'd0};
//assign acc1_loc[1]= {ctr[5:3], 3'd1};
//assign acc1_loc[2]= {ctr[5:3], 3'd2};
//assign acc1_loc[3]= {ctr[5:3], 3'd3};
//assign acc1_loc[4]= {ctr[5:3], 3'd4};
//assign acc1_loc[5]= {ctr[5:3], 3'd5};
//assign acc1_loc[6]= {ctr[5:3], 3'd6};
//assign acc1_loc[7]= {ctr[5:3], 3'd7};
assign acc1_loc[0]= {Input_turns[2:0], 3'd0};
assign acc1_loc[1]= {Input_turns[2:0], 3'd1};
assign acc1_loc[2]= {Input_turns[2:0], 3'd2};
assign acc1_loc[3]= {Input_turns[2:0], 3'd3};
assign acc1_loc[4]= {Input_turns[2:0], 3'd4};
assign acc1_loc[5]= {Input_turns[2:0], 3'd5};
assign acc1_loc[6]= {Input_turns[2:0], 3'd6};
assign acc1_loc[7]= {Input_turns[2:0], 3'd7};

wire [5:0]acc2_loc[0:7];                        // To specify T.M.T' partial products location
//assign acc2_loc[0] = {3'd0, ctr[2:0]};
//assign acc2_loc[1] = {3'd1, ctr[2:0]};
//assign acc2_loc[2] = {3'd2, ctr[2:0]};
//assign acc2_loc[3] = {3'd3, ctr[2:0]};
//assign acc2_loc[4] = {3'd4, ctr[2:0]};
//assign acc2_loc[5] = {3'd5, ctr[2:0]};
//assign acc2_loc[6] = {3'd6, ctr[2:0]};
//assign acc2_loc[7] = {3'd7, ctr[2:0]};
assign acc2_loc[0] = {3'd0, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[1] = {3'd1, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[2] = {3'd2, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[3] = {3'd3, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[4] = {3'd4, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[5] = {3'd5, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[6] = {3'd6, Acc2_ctr[2:0]-1'b1};
assign acc2_loc[7] = {3'd7, Acc2_ctr[2:0]-1'b1};

wire [0:22]before_Q[0:63];
wire [0:53] after_DCT_0, after_DCT_1, after_DCT_2, after_DCT_3, after_DCT_4, after_DCT_5, after_DCT_6, after_DCT_7;
wire [0:22] b_Q0, b_Q1, b_Q2, b_Q3, b_Q4, b_Q5, b_Q6, b_Q7;
// Acc2: 38 bits = 14(integral)+24(fractional) ->14+9 (rounding off before quantisation)
assign after_DCT_0 = Acc2[acc2_loc[0]-1'b1];
assign after_DCT_1 = Acc2[acc2_loc[1]-1'b1];
assign after_DCT_2 = Acc2[acc2_loc[2]-1'b1];
assign after_DCT_3 = Acc2[acc2_loc[3]-1'b1];
assign after_DCT_4 = Acc2[acc2_loc[4]-1'b1];
assign after_DCT_5 = Acc2[acc2_loc[5]-1'b1];
assign after_DCT_6 = Acc2[acc2_loc[6]-1'b1];
assign after_DCT_7 = Acc2[acc2_loc[7]-1'b1];

assign b_Q0 = after_DCT_0[0] ? ~(after_DCT_0[0:22]) + 1'b1 : after_DCT_0[0:22]; // Retaining 23 M.S.Bits (14+9)
assign b_Q1 = after_DCT_1[0] ? ~(after_DCT_1[0:22]) + 1'b1 : after_DCT_1[0:22]; // Magnitude of the values
assign b_Q2 = after_DCT_2[0] ? ~(after_DCT_2[0:22]) + 1'b1 : after_DCT_2[0:22];
assign b_Q3 = after_DCT_3[0] ? ~(after_DCT_3[0:22]) + 1'b1 : after_DCT_3[0:22];
assign b_Q4 = after_DCT_4[0] ? ~(after_DCT_4[0:22]) + 1'b1 : after_DCT_4[0:22];
assign b_Q5 = after_DCT_5[0] ? ~(after_DCT_5[0:22]) + 1'b1 : after_DCT_5[0:22];
assign b_Q6 = after_DCT_6[0] ? ~(after_DCT_6[0:22]) + 1'b1 : after_DCT_6[0:22];
assign b_Q7 = after_DCT_7[0] ? ~(after_DCT_7[0:22]) + 1'b1 : after_DCT_7[0:22];

mul_Q m30(.B(Q[acc2_loc[0]-1'b1]),.A(b_Q0),.C(Quantised_0));   // Quantisation
mul_Q m31(.B(Q[acc2_loc[1]-1'b1]),.A(b_Q1),.C(Quantised_1));    // (14+9) x (0+12) = (14+21)
mul_Q m32(.B(Q[acc2_loc[2]-1'b1]),.A(b_Q2),.C(Quantised_2));
mul_Q m33(.B(Q[acc2_loc[3]-1'b1]),.A(b_Q3),.C(Quantised_3));
mul_Q m34(.B(Q[acc2_loc[4]-1'b1]),.A(b_Q4),.C(Quantised_4));
mul_Q m35(.B(Q[acc2_loc[5]-1'b1]),.A(b_Q5),.C(Quantised_5));
mul_Q m36(.B(Q[acc2_loc[6]-1'b1]),.A(b_Q6),.C(Quantised_6));
mul_Q m37(.B(Q[acc2_loc[7]-1'b1]),.A(b_Q7),.C(Quantised_7));

always@(posedge clk)
begin
    if(rst == 1'b1) begin
        ready <= 1'b1;
        DCT_done<=1'b0;
        Quantisation_done<=1'b0;
        ctr<=7'd0;
        {Acc[0], Acc[1], Acc[2], Acc[3], Acc[4], Acc[5], Acc[6], Acc[7],
        Acc[8],Acc[9], Acc[10], Acc[11], Acc[12], Acc[13], Acc[14], Acc[15],
        Acc[16], Acc[17], Acc[18], Acc[19], Acc[20], Acc[21], Acc[22], Acc[23],
        Acc[24], Acc[25], Acc[26], Acc[27], Acc[28], Acc[29], Acc[30], Acc[31],
        Acc[32], Acc[33], Acc[34], Acc[35], Acc[36], Acc[37], Acc[38], Acc[39],
        Acc[40], Acc[41], Acc[42], Acc[43], Acc[44], Acc[45], Acc[46], Acc[47], 
        Acc[48], Acc[49], Acc[50], Acc[51], Acc[52], Acc[53], Acc[54], Acc[55], 
        Acc[56], Acc[57], Acc[58], Acc[59], Acc[60], Acc[61], Acc[62], Acc[63]} <= 1472'd0;
        
        {Acc2[0], Acc2[1], Acc2[2], Acc2[3], Acc2[4], Acc2[5], Acc2[6], Acc2[7],
         Acc2[8], Acc2[9], Acc2[10], Acc2[11], Acc2[12], Acc2[13], Acc2[14], Acc2[15],
         Acc2[16], Acc2[17], Acc2[18], Acc2[19], Acc2[20], Acc2[21], Acc2[22], Acc2[23],
         Acc2[24], Acc2[25], Acc2[26], Acc2[27], Acc2[28], Acc2[29], Acc2[30], Acc2[31],
         Acc2[32], Acc2[33], Acc2[34], Acc2[35], Acc2[36], Acc2[37], Acc2[38], Acc2[39],
         Acc2[40], Acc2[41], Acc2[42], Acc2[43], Acc2[44], Acc2[45], Acc2[46], Acc2[47],
         Acc2[48], Acc2[49], Acc2[50], Acc2[51], Acc2[52], Acc2[53], Acc2[54], Acc2[55],
         Acc2[56], Acc2[57], Acc2[58], Acc2[59], Acc2[60], Acc2[61], Acc2[62], Acc2[63]} <=2432'd0;
         
         {RL[0], RL[1], RL[2], RL[3], RL[4], RL[5], RL[6], RL[7], 
          RL[8], RL[9], RL[10], RL[11], RL[12], RL[13], RL[14], RL[15], 
          RL[16], RL[17], RL[18], RL[19], RL[20], RL[21], RL[22], RL[23], 
          RL[24], RL[25], RL[26], RL[27], RL[28], RL[29], RL[30], RL[31], 
          RL[32], RL[33], RL[34], RL[35], RL[36], RL[37], RL[38], RL[39], 
          RL[40], RL[41], RL[42], RL[43], RL[44], RL[45], RL[46], RL[47], 
          RL[48], RL[49], RL[50], RL[51], RL[52], RL[53], RL[54], RL[55], 
          RL[56], RL[57], RL[58], RL[59], RL[60], RL[61], RL[62], RL[63]} <= 768'd0;
          stop_RLE = 1'b0;
          j = 0;     index = 0;  i=0;
          
          {After_Q[0], After_Q[1], After_Q[2], After_Q[3], After_Q[4], After_Q[5], After_Q[6], After_Q[7], 
           After_Q[8], After_Q[9], After_Q[10], After_Q[11], After_Q[12], After_Q[13], After_Q[14], After_Q[15], 
           After_Q[16], After_Q[17], After_Q[18], After_Q[19], After_Q[20], After_Q[21], After_Q[22], After_Q[23], 
           After_Q[24], After_Q[25], After_Q[26], After_Q[27], After_Q[28], After_Q[29], After_Q[30], After_Q[31], 
           After_Q[32], After_Q[33], After_Q[34], After_Q[35], After_Q[36], After_Q[37], After_Q[38], After_Q[39], 
           After_Q[40], After_Q[41], After_Q[42], After_Q[43], After_Q[44], After_Q[45], After_Q[46], After_Q[47], 
           After_Q[48], After_Q[49], After_Q[50], After_Q[51], After_Q[52], After_Q[53], After_Q[54], After_Q[55], 
           After_Q[56], After_Q[57], After_Q[58], After_Q[59], After_Q[60], After_Q[61], After_Q[62], After_Q[63]} <= 896'd0;  // 14-bits*64
          
          ctr_h <= 7'd0;
          dc_h <= 1'b1;     // DC coefficient
          last_non_zeroes_RL <= 7'd0;     // To track end of input (Zig-zag pattern instance followed only by zeroes)
          zeroes_RL <= 7'd0;
          
          last_non_zero_terms_RL <= 7'd0;
          zero_terms_RL <= 7'd0;
          final_term_H <= 1'b0;
          done <= 1'b0;
          
          Acc_ctr <= 4'd1;
          Acc2_ctr <= 4'd8;
          Input_turns <= 4'd0;
          changed_ctr <= 7'd0;
          acc_loc_ctr <= 7'd0;  latch <= 1'b0;
          Valid_output <= 1'b0;
    end
    else begin
    if(start_MCU == 1'b1) begin//
        if(ctr<=7'd63 && ready == 1'b1 && DCT_done == 1'd0 ) begin    // T*M Matrix multiplication   // || Acc_ctr != 4'd0
            if(Acc_en == 1'b1 || Acc_ctr != 4'd0) begin
                Acc[acc1_loc[0]]<=Acc[acc1_loc[0]]+PP[0];
                Acc[acc1_loc[1]]<=Acc[acc1_loc[1]]+PP[1];
                Acc[acc1_loc[2]]<=Acc[acc1_loc[2]]+PP[2];
                Acc[acc1_loc[3]]<=Acc[acc1_loc[3]]+PP[3];
                Acc[acc1_loc[4]]<=Acc[acc1_loc[4]]+PP[4];
                Acc[acc1_loc[5]]<=Acc[acc1_loc[5]]+PP[5];
                Acc[acc1_loc[6]]<=Acc[acc1_loc[6]]+PP[6];
                Acc[acc1_loc[7]]<=Acc[acc1_loc[7]]+PP[7];
            end
            if(enable == 1'b1) begin
                Acc_ctr <= 4'd1;
//                Acc2_ctr <= Acc2_ctr + 1'b1;
                Acc_done <= 1'b0;
            end
            else begin
                if(Acc_ctr > 4'd0) begin
                    Acc_ctr <= Acc_ctr-1'b1;
                end
            end
        end
        
        if(enable == 1'b1) begin
            ctr<=ctr+7'd1;
//            changed_ctr <= changed_ctr + 7'd1 - Acc_done;
            changed_ctr <= ctr + 7'd1;
            Acc_en <= 1'b1;
        end
        else begin
            Acc_en <= 1'b0;
        end
        
        if(Acc_ctr == 4'd0) begin
            Acc_done <= 1'b1;
            if(Acc_done == 1'b0) begin
                Acc2_ctr <= 4'd0;
            end
            else begin
                if(Acc2_ctr == 4'd0) begin
                    Input_turns <= Input_turns + 1'b1;
                    changed_ctr <= changed_ctr + 1'b1;
                end
            end
        end
        
        if(Acc2_ctr == 4'd1 || latch == 1'b1) begin
            acc_loc_ctr <= acc_loc_ctr + 1'b1;
            if(acc_loc_ctr[2:0] < 3'd7) begin
                latch <= 1'b1;
            end
            else begin
                latch <= 1'b0;
            end
        end
        
        if(ctr>=7'd7 && ctr<=7'd72) // && DCT_done == 1'd0  //ctr>=7'd8
        begin
            if(DCT_done == 1'd0 && Acc_ctr == 4'd0 && (Acc2_ctr < 4'd8 || latch == 1'b1)) begin    //enable == 1'b1 || 
                if(changed_ctr[2:0] == 3'd0) begin
                    Acc2[acc2_loc[0]]<=Acc2[acc2_loc[0]]+PP2[0];
                    Acc2[acc2_loc[1]]<=Acc2[acc2_loc[1]]+PP2[1];
                    Acc2[acc2_loc[2]]<=Acc2[acc2_loc[2]]+PP2[2];
                    Acc2[acc2_loc[3]]<=Acc2[acc2_loc[3]]+PP2[3];
                    Acc2[acc2_loc[4]]<=Acc2[acc2_loc[4]]+PP2[4];
                    Acc2[acc2_loc[5]]<=Acc2[acc2_loc[5]]+PP2[5];
                    Acc2[acc2_loc[6]]<=Acc2[acc2_loc[6]]+PP2[6];
                    Acc2[acc2_loc[7]]<=Acc2[acc2_loc[7]]+PP2[7];
                end
//                if(enable == 1'b1) begin
//                    Acc2_ctr <= Acc2_ctr + 4'd1;
//                end
//                else begin
                    if(Acc2_ctr < 4'd8) begin
                        Acc2_ctr <= Acc2_ctr + 1'b1;
                    end
//                end
            end
            
            if(ctr>7'd63) begin
                ready <= 1'b0;  // Inputs should not be provided                
            end

            if(changed_ctr >= 7'd64 && Quantisation_done == 1'd0 && Acc2_ctr >= 4'd2) begin
                if(after_DCT_0[0] == 0)    // Attaching sign back (as absolute is applied before quantisation)
                    After_Q[acc_loc_ctr - 57] <= Quantised_0[0:13]+Quantised_0[14];   //Rounding
                else
                    After_Q[acc_loc_ctr - 57] <= ~(Quantised_0[0:13]+Quantised_0[14]) + 1'b1;

                if(after_DCT_1[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 8] <= Quantised_1[0:13]+Quantised_1[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 8] <= ~(Quantised_1[0:13]+Quantised_1[14]) + 1'b1;
                    
                if(after_DCT_2[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 16] <= Quantised_2[0:13]+Quantised_2[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 16] <= ~(Quantised_2[0:13]+Quantised_2[14]) + 1'b1;
                                        
                if(after_DCT_3[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 24] <= Quantised_3[0:13]+Quantised_3[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 24] <= ~(Quantised_3[0:13]+Quantised_3[14]) + 1'b1;

                if(after_DCT_4[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 32] <= Quantised_4[0:13]+Quantised_4[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 32] <= ~(Quantised_4[0:13]+Quantised_4[14]) + 1'b1;

                if(after_DCT_5[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 40] <= Quantised_5[0:13]+Quantised_5[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 40] <= ~(Quantised_5[0:13]+Quantised_5[14]) + 1'b1;

                if(after_DCT_6[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 48] <= Quantised_6[0:13]+Quantised_6[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 48] <= ~(Quantised_6[0:13]+Quantised_6[14]) + 1'b1;

                if(after_DCT_7[0] == 0)
                    After_Q[acc_loc_ctr - 57 + 56] <= Quantised_7[0:13]+Quantised_7[14]; 
                else
                    After_Q[acc_loc_ctr - 57 + 56] <= ~(Quantised_7[0:13]+Quantised_7[14]) + 1'b1;

            end
        end
        
        if(changed_ctr == 7'd64 && Acc2_ctr == 4'd8) begin
            DCT_done<=1'b1;
        end
        if(DCT_done == 1'd1) begin
            Quantisation_done <= 1'b1;
        end
        
        if(Quantisation_done == 1'b1 && stop_RLE == 1'b0) begin
            in1 = After_ZZ[i];    in2 = After_ZZ[i+1];
            if(in1 != 14'd0 && in2 != 14'd0) begin      // non-zero,non-zero
                RL[j] = {index, in1[6:13]};     // Termination  //L.S.Bits [6:13] are considered as the maximum possible value is 63
                RL[j+1] = {4'd0, in2[6:13]};
                j = j+2;
                index = 6'd0;                      // frequency reset
                
//                last_non_zeroes_RL <= last_non_zeroes_RL + 2 + zeroes_RL;
//                zeroes_RL <= 7'd0;     // To track end of input (Zig-zag pattern instance followed only by zeroes)
                
                last_non_zero_terms_RL <= last_non_zero_terms_RL + 2 + zero_terms_RL;
                zero_terms_RL <= 7'd0;
            end
            else if (in1 == 14'd0 && in2 != 14'd0) begin    // zero, non-zero
                if( index < 15 ) begin
                    RL[j] = {index+1'b1, in2[6:13]};
                    j = j+1;    index = 6'd0;
                    
                    last_non_zero_terms_RL <= last_non_zero_terms_RL + 1 + zero_terms_RL;
                    zero_terms_RL <= 7'd0;
                end
                else begin                      // Maximum allowable frequency (15) is reached
                    RL[j] = {4'b1111, 8'd0};
                    RL[j+1] = {4'b0000, in2[6:13]};
                    j = j+2;
                    index = 6'd0;
                    
                    last_non_zero_terms_RL <= last_non_zero_terms_RL + 2 + zero_terms_RL;
                    zero_terms_RL <= 7'd0;
                end
                
//                last_non_zeroes_RL <= last_non_zeroes_RL + 2 + zeroes_RL;
//                zeroes_RL <= 7'd0;
            end
            else if(in1 != 14'd0 && in2 == 14'd0) begin     // non-zero, zero
                RL[j] = {index, in1[6:13]};
                j = j+1;
                index = 6'd1;
                
//                last_non_zeroes_RL <= last_non_zeroes_RL + 1 + zeroes_RL;
//                zeroes_RL <= 7'd1;
                
                last_non_zero_terms_RL <= last_non_zero_terms_RL + 1 + zero_terms_RL;
                zero_terms_RL <= 7'd0;
            end
            else begin                          // ( in1 = 0 and in2 = 0 )
                if(index < 6'd14) begin
                    index = index + 2'd2;
                    if(i == 6'd62) begin        // All elements are considered
                        RL[j] = {index-1'b1, 8'd0};
                        j = j+1;
                        stop_RLE = 1'b1;
                        
                        zero_terms_RL <= zero_terms_RL + 1;
                    end
                end
                else if (index == 6'd14) begin
                    RL[j] = {4'b1111, 8'd0};
                    j = j+1;
                    index = 6'd0;
                    zero_terms_RL <= zero_terms_RL + 1;
                end
                else begin                      // index = 15
                    RL[j] = {4'b1111, 8'd0};
                    j = j+1;
                    index = 6'd1;
                    zero_terms_RL <= zero_terms_RL + 1;
                end
                
//                zeroes_RL <= zeroes_RL + 2;     // To track end of input (Zig-zag pattern instance followed only by zeroes)
            end
            if(i != 6'd62) begin
                i = i+2;
            end
        end

        if(stop_RLE == 1'b1) begin      // Huffman coding
            RL_present <= RL[ctr_h];        // for example Run Length output is (2,5)
            if(ctr_h >= 7'd2) begin
                Valid_output <= 1'b1;
            end
            if(ctr_h >= 7'd2) begin         // 1 delay for value and 1 delay for Huffman module
                dc_h <= 1'b0;                   // for AC values
            end
            if(ctr_h > last_non_zero_terms_RL) begin
                final_term_H <= 1'b1;
            end
            if(final_term_H==1'b1) begin
                done <= 1'b1;
                Valid_output <= 1'b0;
            end
            ctr_h <= ctr_h+1;
        end
        
    end     // Start_MCU if
    end     // Reset = 0

end     // always

wire [0:5] Z_loc [0:63];

assign {Z_loc[0], Z_loc[1], Z_loc[2], Z_loc[3], Z_loc[4], Z_loc[5], Z_loc[6], Z_loc[7], 
        Z_loc[8], Z_loc[9], Z_loc[10], Z_loc[11], Z_loc[12], Z_loc[13], Z_loc[14], Z_loc[15], 
        Z_loc[16], Z_loc[17], Z_loc[18], Z_loc[19], Z_loc[20], Z_loc[21], Z_loc[22], Z_loc[23], 
        Z_loc[24], Z_loc[25], Z_loc[26], Z_loc[27], Z_loc[28], Z_loc[29], Z_loc[30], Z_loc[31], 
        Z_loc[32], Z_loc[33], Z_loc[34], Z_loc[35], Z_loc[36], Z_loc[37], Z_loc[38], Z_loc[39], 
        Z_loc[40], Z_loc[41], Z_loc[42], Z_loc[43], Z_loc[44], Z_loc[45], Z_loc[46], Z_loc[47], 
        Z_loc[48], Z_loc[49], Z_loc[50], Z_loc[51], Z_loc[52], Z_loc[53], Z_loc[54], Z_loc[55], 
        Z_loc[56], Z_loc[57], Z_loc[58], Z_loc[59], Z_loc[60], Z_loc[61], Z_loc[62], Z_loc[63]}
        = {6'd0, 
           6'd1, 6'd8, 
           6'd16, 6'd9, 6'd2, 
           6'd3, 6'd10, 6'd17, 6'd24, 
           6'd32, 6'd25, 6'd18, 6'd11, 6'd4, 
           6'd5, 6'd12, 6'd19, 6'd26, 6'd33, 6'd40, 
           6'd48, 6'd41, 6'd34, 6'd27, 6'd20, 6'd13, 6'd6, 
           6'd7, 6'd14, 6'd21, 6'd28, 6'd35, 6'd42, 6'd49, 6'd56, 
           6'd57, 6'd50, 6'd43, 6'd36, 6'd29, 6'd22, 6'd15, 
           6'd23, 6'd30, 6'd37, 6'd44, 6'd51, 6'd58, 
           6'd59, 6'd52, 6'd45, 6'd38, 6'd31, 
           6'd39, 6'd46, 6'd53, 6'd60, 
           6'd61, 6'd54, 6'd47, 
           6'd55, 6'd62, 
           6'd63};

//reg [0:13]After_Q[0:63];   // Final result (Quantised)

// Zig-Zag reordering
assign {After_ZZ[0], After_ZZ[1], After_ZZ[2], After_ZZ[3], After_ZZ[4], After_ZZ[5], After_ZZ[6], After_ZZ[7], 
        After_ZZ[8], After_ZZ[9], After_ZZ[10], After_ZZ[11], After_ZZ[12], After_ZZ[13], After_ZZ[14], After_ZZ[15], 
        After_ZZ[16], After_ZZ[17], After_ZZ[18], After_ZZ[19], After_ZZ[20], After_ZZ[21], After_ZZ[22], After_ZZ[23], 
        After_ZZ[24], After_ZZ[25], After_ZZ[26], After_ZZ[27], After_ZZ[28], After_ZZ[29], After_ZZ[30], After_ZZ[31], 
        After_ZZ[32], After_ZZ[33], After_ZZ[34], After_ZZ[35], After_ZZ[36], After_ZZ[37], After_ZZ[38], After_ZZ[39], 
        After_ZZ[40], After_ZZ[41], After_ZZ[42], After_ZZ[43], After_ZZ[44], After_ZZ[45], After_ZZ[46], After_ZZ[47], 
        After_ZZ[48], After_ZZ[49], After_ZZ[50], After_ZZ[51], After_ZZ[52], After_ZZ[53], After_ZZ[54], After_ZZ[55], 
        After_ZZ[56], After_ZZ[57], After_ZZ[58], After_ZZ[59], After_ZZ[60], After_ZZ[61], After_ZZ[62], After_ZZ[63]}        
        = (Quantisation_done==1'b1) ? 
        {After_Q[Z_loc[0]], After_Q[Z_loc[1]], After_Q[Z_loc[2]], After_Q[Z_loc[3]], After_Q[Z_loc[4]], After_Q[Z_loc[5]], After_Q[Z_loc[6]], After_Q[Z_loc[7]], 
         After_Q[Z_loc[8]], After_Q[Z_loc[9]], After_Q[Z_loc[10]], After_Q[Z_loc[11]], After_Q[Z_loc[12]], After_Q[Z_loc[13]], After_Q[Z_loc[14]], After_Q[Z_loc[15]], 
         After_Q[Z_loc[16]], After_Q[Z_loc[17]], After_Q[Z_loc[18]], After_Q[Z_loc[19]], After_Q[Z_loc[20]], After_Q[Z_loc[21]], After_Q[Z_loc[22]], After_Q[Z_loc[23]], 
         After_Q[Z_loc[24]], After_Q[Z_loc[25]], After_Q[Z_loc[26]], After_Q[Z_loc[27]], After_Q[Z_loc[28]], After_Q[Z_loc[29]], After_Q[Z_loc[30]], After_Q[Z_loc[31]], 
         After_Q[Z_loc[32]], After_Q[Z_loc[33]], After_Q[Z_loc[34]], After_Q[Z_loc[35]], After_Q[Z_loc[36]], After_Q[Z_loc[37]], After_Q[Z_loc[38]], After_Q[Z_loc[39]], 
         After_Q[Z_loc[40]], After_Q[Z_loc[41]], After_Q[Z_loc[42]], After_Q[Z_loc[43]], After_Q[Z_loc[44]], After_Q[Z_loc[45]], After_Q[Z_loc[46]], After_Q[Z_loc[47]], 
         After_Q[Z_loc[48]], After_Q[Z_loc[49]], After_Q[Z_loc[50]], After_Q[Z_loc[51]], After_Q[Z_loc[52]], After_Q[Z_loc[53]], After_Q[Z_loc[54]], After_Q[Z_loc[55]], 
         After_Q[Z_loc[56]], After_Q[Z_loc[57]], After_Q[Z_loc[58]], After_Q[Z_loc[59]], After_Q[Z_loc[60]], After_Q[Z_loc[61]], After_Q[Z_loc[62]], After_Q[Z_loc[63]]} : 512'd0;
assign present_dc_value = After_Q[0];
Size_and_code S_a_c(RL_present,clk,Size_h,Suffix_code,value_h,run_h);
wire [0:13] dc_difference;
assign dc_difference = first_MCU ? present_dc_value : present_dc_value-prev_dc_value;
Huffman_encoding H_e(clk,dc_h,dc_difference,run_h,Size_h,Suffix_code,final_term_H,Output);
endmodule

/*
module tb;
reg clk, rst;
reg [7:0] Input;
wire Output, ready;

DCT_2D m1(Input,rst,clk,ready,Output);

initial begin
rst = 1'b1;
end

always 
begin
    clk = 1'b1; 
    #20; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #20; // low for 20 * timescale = 20 ns
    
end

always @(posedge clk) begin
    Input = 8'd2;
    rst = 1'b0;
end
endmodule
*/