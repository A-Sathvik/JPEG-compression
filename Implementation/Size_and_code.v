`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2021 11:22:48
// Design Name: 
// Module Name: Size_and_code
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// OM
//////////////////////////////////////////////////////////////////////////////////


module Size_and_code(RL_value,clk,Size,Suffix_code,value,run);
input [0:11] RL_value;
input clk;
output reg [2:0] Size;
output reg [6:0] Suffix_code;
output reg [0:7] value;
output reg [0:3] run;

always@(posedge clk) begin
        value <= RL_value[4:11];
        run <= RL_value[0:3];
        case(RL_value[4:11])
                8'd153: begin    //-103
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011000;
                        end
                8'd154: begin    //-102
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011001;
                        end
                8'd155: begin    //-101
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011010;
                        end
                8'd156: begin    //-100
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011011;
                        end
                8'd157: begin    //-99
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011100;
                        end
                8'd158: begin    //-98
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011101;
                        end
                8'd159: begin    //-97
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011110;
                        end
                8'd160: begin    //-96
                               Size <= 3'd7;
                               Suffix_code <= 7'b0011111;
                        end
                8'd161: begin    //-95
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100000;
                        end
                8'd162: begin    //-94
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100001;
                        end
                8'd163: begin    //-93
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100010;
                        end
                8'd164: begin    //-92
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100011;
                        end
                8'd165: begin    //-91
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100100;
                        end
                8'd166: begin    //-90
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100101;
                        end
                8'd167: begin    //-89
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100110;
                        end
                8'd168: begin    //-88
                               Size <= 3'd7;
                               Suffix_code <= 7'b0100111;
                        end
                8'd169: begin    //-87
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101000;
                        end
                8'd170: begin    //-86
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101001;
                        end
                8'd171: begin    //-85
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101010;
                        end
                8'd172: begin    //-84
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101011;
                        end
                8'd173: begin    //-83
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101100;
                        end
                8'd174: begin    //-82
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101101;
                        end
                8'd175: begin    //-81
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101110;
                        end
                8'd176: begin    //-80
                               Size <= 3'd7;
                               Suffix_code <= 7'b0101111;
                        end
                8'd177: begin    //-79
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110000;
                        end
                8'd178: begin    //-78
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110001;
                        end
                8'd179: begin    //-77
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110010;
                        end
                8'd180: begin    //-76
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110011;
                        end
                8'd181: begin    //-75
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110100;
                        end
                8'd182: begin    //-74
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110101;
                        end
                8'd183: begin    //-73
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110110;
                        end
                8'd184: begin    //-72
                               Size <= 3'd7;
                               Suffix_code <= 7'b0110111;
                        end
                8'd185: begin    //-71
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111000;
                        end
                8'd186: begin    //-70
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111001;
                        end
                8'd187: begin    //-69
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111010;
                        end
                8'd188: begin    //-68
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111011;
                        end
                8'd189: begin    //-67
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111100;
                        end
                8'd190: begin    //-66
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111101;
                        end
                8'd191: begin    //-65
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111110;
                        end
                8'd192: begin    //-64
                               Size <= 3'd7;
                               Suffix_code <= 7'b0111111;
                        end
                8'd193: begin    //-63
                               Size <= 3'd6;
                               Suffix_code <= 6'b000000;
                        end
                8'd194: begin    //-62
                               Size <= 3'd6;
                               Suffix_code <= 6'b000001;
                        end
                8'd195: begin    //-61
                               Size <= 3'd6;
                               Suffix_code <= 6'b000010;
                        end
                8'd196: begin    //-60
                               Size <= 3'd6;
                               Suffix_code <= 6'b000011;
                        end
                8'd197: begin    //-59
                               Size <= 3'd6;
                               Suffix_code <= 6'b000100;
                        end
                8'd198: begin    //-58
                               Size <= 3'd6;
                               Suffix_code <= 6'b000101;
                        end
                8'd199: begin    //-57
                               Size <= 3'd6;
                               Suffix_code <= 6'b000110;
                        end
                8'd200: begin    //-56
                               Size <= 3'd6;
                               Suffix_code <= 6'b000111;
                        end
                8'd201: begin    //-55
                               Size <= 3'd6;
                               Suffix_code <= 6'b001000;
                        end
                8'd202: begin    //-54
                               Size <= 3'd6;
                               Suffix_code <= 6'b001001;
                        end
                8'd203: begin    //-53
                               Size <= 3'd6;
                               Suffix_code <= 6'b001010;
                        end
                8'd204: begin    //-52
                               Size <= 3'd6;
                               Suffix_code <= 6'b001011;
                        end
                8'd205: begin    //-51
                               Size <= 3'd6;
                               Suffix_code <= 6'b001100;
                        end
                8'd206: begin    //-50
                               Size <= 3'd6;
                               Suffix_code <= 6'b001101;
                        end
                8'd207: begin    //-49
                               Size <= 3'd6;
                               Suffix_code <= 6'b001110;
                        end
                8'd208: begin    //-48
                               Size <= 3'd6;
                               Suffix_code <= 6'b001111;
                        end
                8'd209: begin    //-47
                               Size <= 3'd6;
                               Suffix_code <= 6'b010000;
                        end
                8'd210: begin    //-46
                               Size <= 3'd6;
                               Suffix_code <= 6'b010001;
                        end
                8'd211: begin    //-45
                               Size <= 3'd6;
                               Suffix_code <= 6'b010010;
                        end
                8'd212: begin    //-44
                               Size <= 3'd6;
                               Suffix_code <= 6'b010011;
                        end
                8'd213: begin    //-43
                               Size <= 3'd6;
                               Suffix_code <= 6'b010100;
                        end
                8'd214: begin    //-42
                               Size <= 3'd6;
                               Suffix_code <= 6'b010101;
                        end
                8'd215: begin    //-41
                               Size <= 3'd6;
                               Suffix_code <= 6'b010110;
                        end
                8'd216: begin    //-40
                               Size <= 3'd6;
                               Suffix_code <= 6'b010111;
                        end
                8'd217: begin    //-39
                               Size <= 3'd6;
                               Suffix_code <= 6'b011000;
                        end
                8'd218: begin    //-38
                               Size <= 3'd6;
                               Suffix_code <= 6'b011001;
                        end
                8'd219: begin    //-37
                               Size <= 3'd6;
                               Suffix_code <= 6'b011010;
                        end
                8'd220: begin    //-36
                               Size <= 3'd6;
                               Suffix_code <= 6'b011011;
                        end
                8'd221: begin    //-35
                               Size <= 3'd6;
                               Suffix_code <= 6'b011100;
                        end
                8'd222: begin    //-34
                               Size <= 3'd6;
                               Suffix_code <= 6'b011101;
                        end
                8'd223: begin    //-33
                               Size <= 3'd6;
                               Suffix_code <= 6'b011110;
                        end
                8'd224: begin    //-32
                               Size <= 3'd6;
                               Suffix_code <= 6'b011111;
                        end
                8'd225: begin    //-31
                               Size <= 3'd5;
                               Suffix_code <= 5'b00000;
                        end
                8'd226: begin    //-30
                               Size <= 3'd5;
                               Suffix_code <= 5'b00001;
                        end
                8'd227: begin    //-29
                               Size <= 3'd5;
                               Suffix_code <= 5'b00010;
                        end
                8'd228: begin    //-28
                               Size <= 3'd5;
                               Suffix_code <= 5'b00011;
                        end
                8'd229: begin    //-27
                               Size <= 3'd5;
                               Suffix_code <= 5'b00100;
                        end
                8'd230: begin    //-26
                               Size <= 3'd5;
                               Suffix_code <= 5'b00101;
                        end
                8'd231: begin    //-25
                               Size <= 3'd5;
                               Suffix_code <= 5'b00110;
                        end
                8'd232: begin    //-24
                               Size <= 3'd5;
                               Suffix_code <= 5'b00111;
                        end
                8'd233: begin    //-23
                               Size <= 3'd5;
                               Suffix_code <= 5'b01000;
                        end
                8'd234: begin    //-22
                               Size <= 3'd5;
                               Suffix_code <= 5'b01001;
                        end
                8'd235: begin    //-21
                               Size <= 3'd5;
                               Suffix_code <= 5'b01010;
                        end
                8'd236: begin    //-20
                               Size <= 3'd5;
                               Suffix_code <= 5'b01011;
                        end
                8'd237: begin    //-19
                               Size <= 3'd5;
                               Suffix_code <= 5'b01100;
                        end
                8'd238: begin    //-18
                               Size <= 3'd5;
                               Suffix_code <= 5'b01101;
                        end
                8'd239: begin    //-17
                               Size <= 3'd5;
                               Suffix_code <= 5'b01110;
                        end
                8'd240: begin    //-16
                               Size <= 3'd5;
                               Suffix_code <= 5'b01111;
                        end
                8'd241: begin    //-15
                               Size <= 3'd4;
                               Suffix_code <= 4'b0000;
                        end
                8'd242: begin    //-14
                               Size <= 3'd4;
                               Suffix_code <= 4'b0001;
                        end
                8'd243: begin    //-13
                               Size <= 3'd4;
                               Suffix_code <= 4'b0010;
                        end
                8'd244: begin    //-12
                               Size <= 3'd4;
                               Suffix_code <= 4'b0011;
                        end
                8'd245: begin    //-11
                               Size <= 3'd4;
                               Suffix_code <= 4'b0100;
                        end
                8'd246: begin    //-10
                               Size <= 3'd4;
                               Suffix_code <= 4'b0101;
                        end
                8'd247: begin    //-9
                               Size <= 3'd4;
                               Suffix_code <= 4'b0110;
                        end
                8'd248: begin    //-8
                               Size <= 3'd4;
                               Suffix_code <= 4'b0111;
                        end
                8'd249: begin    //-7
                               Size <= 2'd3;
                               Suffix_code <= 3'b000;
                        end
                8'd250: begin    //-6
                               Size <= 2'd3;
                               Suffix_code <= 3'b001;
                        end
                8'd251: begin    //-5
                               Size <= 2'd3;
                               Suffix_code <= 3'b010;
                        end
                8'd252: begin    //-4
                               Size <= 2'd3;
                               Suffix_code <= 3'b011;
                        end
                8'd253: begin    //-3
                               Size <= 2'd2;
                               Suffix_code <= 2'b00;
                        end
                8'd254: begin    //-2
                               Size <= 2'd2;
                               Suffix_code <= 2'b01;
                        end
                8'd255: begin    //-1
                               Size <= 1'd1;
                               Suffix_code <= 1'b0;
                        end
                8'd0: begin    //0
                             Size <= 1'd0;
                        end
                8'd1: begin    //1
                             Size <= 1'd1;
                             Suffix_code <= 1'b1;
                        end
                8'd2: begin    //2
                             Size <= 2'd2;
                             Suffix_code <= 2'b10;
                        end
                8'd3: begin    //3
                             Size <= 2'd2;
                             Suffix_code <= 2'b11;
                        end
                8'd4: begin    //4
                             Size <= 2'd3;
                             Suffix_code <= 3'b100;
                        end
                8'd5: begin    //5
                             Size <= 2'd3;
                             Suffix_code <= 3'b101;
                        end
                8'd6: begin    //6
                             Size <= 2'd3;
                             Suffix_code <= 3'b110;
                        end
                8'd7: begin    //7
                             Size <= 2'd3;
                             Suffix_code <= 3'b111;
                        end
                8'd8: begin    //8
                             Size <= 3'd4;
                             Suffix_code <= 4'b1000;
                        end
                8'd9: begin    //9
                             Size <= 3'd4;
                             Suffix_code <= 4'b1001;
                        end
                8'd10: begin    //10
                             Size <= 3'd4;
                             Suffix_code <= 4'b1010;
                        end
                8'd11: begin    //11
                             Size <= 3'd4;
                             Suffix_code <= 4'b1011;
                        end
                8'd12: begin    //12
                             Size <= 3'd4;
                             Suffix_code <= 4'b1100;
                        end
                8'd13: begin    //13
                             Size <= 3'd4;
                             Suffix_code <= 4'b1101;
                        end
                8'd14: begin    //14
                             Size <= 3'd4;
                             Suffix_code <= 4'b1110;
                        end
                8'd15: begin    //15
                             Size <= 3'd4;
                             Suffix_code <= 4'b1111;
                        end
                8'd16: begin    //16
                             Size <= 3'd5;
                             Suffix_code <= 5'b10000;
                        end
                8'd17: begin    //17
                             Size <= 3'd5;
                             Suffix_code <= 5'b10001;
                        end
                8'd18: begin    //18
                             Size <= 3'd5;
                             Suffix_code <= 5'b10010;
                        end
                8'd19: begin    //19
                             Size <= 3'd5;
                             Suffix_code <= 5'b10011;
                        end
                8'd20: begin    //20
                             Size <= 3'd5;
                             Suffix_code <= 5'b10100;
                        end
                8'd21: begin    //21
                             Size <= 3'd5;
                             Suffix_code <= 5'b10101;
                        end
                8'd22: begin    //22
                             Size <= 3'd5;
                             Suffix_code <= 5'b10110;
                        end
                8'd23: begin    //23
                             Size <= 3'd5;
                             Suffix_code <= 5'b10111;
                        end
                8'd24: begin    //24
                             Size <= 3'd5;
                             Suffix_code <= 5'b11000;
                        end
                8'd25: begin    //25
                             Size <= 3'd5;
                             Suffix_code <= 5'b11001;
                        end
                8'd26: begin    //26
                             Size <= 3'd5;
                             Suffix_code <= 5'b11010;
                        end
                8'd27: begin    //27
                             Size <= 3'd5;
                             Suffix_code <= 5'b11011;
                        end
                8'd28: begin    //28
                             Size <= 3'd5;
                             Suffix_code <= 5'b11100;
                        end
                8'd29: begin    //29
                             Size <= 3'd5;
                             Suffix_code <= 5'b11101;
                        end
                8'd30: begin    //30
                             Size <= 3'd5;
                             Suffix_code <= 5'b11110;
                        end
                8'd31: begin    //31
                             Size <= 3'd5;
                             Suffix_code <= 5'b11111;
                        end
                8'd32: begin    //32
                             Size <= 3'd6;
                             Suffix_code <= 6'b100000;
                        end
                8'd33: begin    //33
                             Size <= 3'd6;
                             Suffix_code <= 6'b100001;
                        end
                8'd34: begin    //34
                             Size <= 3'd6;
                             Suffix_code <= 6'b100010;
                        end
                8'd35: begin    //35
                             Size <= 3'd6;
                             Suffix_code <= 6'b100011;
                        end
                8'd36: begin    //36
                             Size <= 3'd6;
                             Suffix_code <= 6'b100100;
                        end
                8'd37: begin    //37
                             Size <= 3'd6;
                             Suffix_code <= 6'b100101;
                        end
                8'd38: begin    //38
                             Size <= 3'd6;
                             Suffix_code <= 6'b100110;
                        end
                8'd39: begin    //39
                             Size <= 3'd6;
                             Suffix_code <= 6'b100111;
                        end
                8'd40: begin    //40
                             Size <= 3'd6;
                             Suffix_code <= 6'b101000;
                        end
                8'd41: begin    //41
                             Size <= 3'd6;
                             Suffix_code <= 6'b101001;
                        end
                8'd42: begin    //42
                             Size <= 3'd6;
                             Suffix_code <= 6'b101010;
                        end
                8'd43: begin    //43
                             Size <= 3'd6;
                             Suffix_code <= 6'b101011;
                        end
                8'd44: begin    //44
                             Size <= 3'd6;
                             Suffix_code <= 6'b101100;
                        end
                8'd45: begin    //45
                             Size <= 3'd6;
                             Suffix_code <= 6'b101101;
                        end
                8'd46: begin    //46
                             Size <= 3'd6;
                             Suffix_code <= 6'b101110;
                        end
                8'd47: begin    //47
                             Size <= 3'd6;
                             Suffix_code <= 6'b101111;
                        end
                8'd48: begin    //48
                             Size <= 3'd6;
                             Suffix_code <= 6'b110000;
                        end
                8'd49: begin    //49
                             Size <= 3'd6;
                             Suffix_code <= 6'b110001;
                        end
                8'd50: begin    //50
                             Size <= 3'd6;
                             Suffix_code <= 6'b110010;
                        end
                8'd51: begin    //51
                             Size <= 3'd6;
                             Suffix_code <= 6'b110011;
                        end
                8'd52: begin    //52
                             Size <= 3'd6;
                             Suffix_code <= 6'b110100;
                        end
                8'd53: begin    //53
                             Size <= 3'd6;
                             Suffix_code <= 6'b110101;
                        end
                8'd54: begin    //54
                             Size <= 3'd6;
                             Suffix_code <= 6'b110110;
                        end
                8'd55: begin    //55
                             Size <= 3'd6;
                             Suffix_code <= 6'b110111;
                        end
                8'd56: begin    //56
                             Size <= 3'd6;
                             Suffix_code <= 6'b111000;
                        end
                8'd57: begin    //57
                             Size <= 3'd6;
                             Suffix_code <= 6'b111001;
                        end
                8'd58: begin    //58
                             Size <= 3'd6;
                             Suffix_code <= 6'b111010;
                        end
                8'd59: begin    //59
                             Size <= 3'd6;
                             Suffix_code <= 6'b111011;
                        end
                8'd60: begin    //60
                             Size <= 3'd6;
                             Suffix_code <= 6'b111100;
                        end
                8'd61: begin    //61
                             Size <= 3'd6;
                             Suffix_code <= 6'b111101;
                        end
                8'd62: begin    //62
                             Size <= 3'd6;
                             Suffix_code <= 6'b111110;
                        end
                8'd63: begin    //63
                             Size <= 3'd6;
                             Suffix_code <= 6'b111111;
                        end
                8'd64: begin    //64
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000000;
                        end
                8'd65: begin    //65
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000001;
                        end
                8'd66: begin    //66
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000010;
                        end
                8'd67: begin    //67
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000011;
                        end
                8'd68: begin    //68
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000100;
                        end
                8'd69: begin    //69
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000101;
                        end
                8'd70: begin    //70
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000110;
                        end
                8'd71: begin    //71
                             Size <= 3'd7;
                             Suffix_code <= 7'b1000111;
                        end
                8'd72: begin    //72
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001000;
                        end
                8'd73: begin    //73
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001001;
                        end
                8'd74: begin    //74
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001010;
                        end
                8'd75: begin    //75
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001011;
                        end
                8'd76: begin    //76
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001100;
                        end
                8'd77: begin    //77
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001101;
                        end
                8'd78: begin    //78
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001110;
                        end
                8'd79: begin    //79
                             Size <= 3'd7;
                             Suffix_code <= 7'b1001111;
                        end
                8'd80: begin    //80
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010000;
                        end
                8'd81: begin    //81
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010001;
                        end
                8'd82: begin    //82
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010010;
                        end
                8'd83: begin    //83
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010011;
                        end
                8'd84: begin    //84
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010100;
                        end
                8'd85: begin    //85
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010101;
                        end
                8'd86: begin    //86
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010110;
                        end
                8'd87: begin    //87
                             Size <= 3'd7;
                             Suffix_code <= 7'b1010111;
                        end
                8'd88: begin    //88
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011000;
                        end
                8'd89: begin    //89
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011001;
                        end
                8'd90: begin    //90
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011010;
                        end
                8'd91: begin    //91
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011011;
                        end
                8'd92: begin    //92
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011100;
                        end
                8'd93: begin    //93
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011101;
                        end
                8'd94: begin    //94
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011110;
                        end
                8'd95: begin    //95
                             Size <= 3'd7;
                             Suffix_code <= 7'b1011111;
                        end
                8'd96: begin    //96
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100000;
                        end
                8'd97: begin    //97
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100001;
                        end
                8'd98: begin    //98
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100010;
                        end
                8'd99: begin    //99
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100011;
                        end
                8'd100: begin    //100
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100100;
                        end
                8'd101: begin    //101
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100101;
                        end
                8'd102: begin    //102
                             Size <= 3'd7;
                             Suffix_code <= 7'b1100110;
                        end
        endcase
end

endmodule
