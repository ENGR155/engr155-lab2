// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab2_skm #(parameter width = 24, parameter [width-1:0] max_count = 4999999) (
    input  logic [3:0] s,
    input  logic [3:0] s_2,
    output logic [6:0] seg,
    output logic [1:0] anode // Pinout for common anode for the transistors
);

    logic int_osc;
    logic multi;

    logic [3:0] s_1;


    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Convert switches into the 7-segment display
    lab2_sevenseg sevenseg_decoder (
        .s   (s_1),
        .seg (seg)
    );

    // Sets up a counter for the multiplexer
    lab2_multiplexer #(
        .width     (24),
        .max_count (4_999_999)
    ) multiplex (
        .clk    (int_osc),
        .multi  (multi)
    );
    
    // Assigning final logic and switching
    assign s = multi ? s_2 : s;

    assign anode[0] = multi;
    assign anode[1] = ~multi;   

endmodule