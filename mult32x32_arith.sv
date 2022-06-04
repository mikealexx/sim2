// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

logic [7:0] mux_4_1_res; //results of the mux's
logic [15:0] mux_2_1_res;

logic [23:0] mult_16_8_res; //result of the 16x8 multiplier

logic [63:0] shifter_0_res; //results of all the shifters
logic [63:0] shifter_8_res;
logic [63:0] shifter_16_res;
logic [63:0] shifter_24_res;
logic [63:0] shifter_32_res;
logic [63:0] shifter_40_res;

logic [63:0] mux_8_1_res; //result of mux 8->1 (shift select)

logic [63:0] adder_64_res; //result of 64 bit adder

always_comb begin
	//mux 4->1 result
	case (a_sel)
		2'b00: mux_4_1_res = a[7:0];
		2'b01: mux_4_1_res = a[15:8];
		2'b10: mux_4_1_res = a[23:16];
		2'b11: mux_4_1_res = a[31:24];
		default: mux_4_1_res = a[7:0];
	endcase
	
	//mux 2->1 result
	case (b_sel)
		1'b0: mux_2_1_res = b[15:0];
		1'b1: mux_2_1_res = b[31:16];
		default: mux_2_1_res = b[15:0];
	endcase
	
	//16x8 multiplier result
	mult_16_8_res = mux_4_1_res * mux_2_1_res;
	
	//shifters results
	shifter_0_res = mult_16_8_res;
	shifter_8_res = mult_16_8_res << 8;
	shifter_16_res = mult_16_8_res << 16;
	shifter_24_res = mult_16_8_res << 24;
	shifter_32_res = mult_16_8_res << 32;
	shifter_40_res = mult_16_8_res << 40;
	
	//mux 8 -> 1 result
	case (shift_sel)
		3'b000: mux_8_1_res = shifter_0_res;
		3'b001: mux_8_1_res = shifter_8_res;
		3'b010: mux_8_1_res = shifter_16_res;
		3'b011: mux_8_1_res = shifter_24_res;
		3'b100: mux_8_1_res = shifter_32_res;
		3'b101: mux_8_1_res = shifter_40_res;
		default: mux_8_1_res = 64'b000;
	endcase
	
	//64 bit adder result
	adder_64_res = product + mux_8_1_res;
end

always_ff @(posedge clk) begin
	//update product register (FF)
	if (reset == 1 || clr_prod == 1) begin
		product <= 0;
	end
	else if (upd_prod == 1) begin
		product <= adder_64_res;
	end
end 

endmodule
