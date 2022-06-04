// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------


// End of your code

endmodule
