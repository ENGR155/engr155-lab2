// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab2_skm #(parameter width = 24, parameter [width-1:0] max_count = 4999999) (
    input  logic [3:0] s,
    input  logic [3:0] s_2,
    output logic [6:0] seg,
    output logic [6:0] seg_2,
    output logic [1:0]multiplex
);

    logic int_osc;
    logic [1:0] multi;



    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Convert switches into the 7-segment display
    lab2_sevenseg sevenseg_decoder (
        .s   (s),
        .seg (seg)
    );
    
    // Convert a second group of switches into the 7-segment display
    lab2_sevenseg sevenseg_decoder_2 (
        .s   (s_2),
        .seg (seg_2)
    );

    // Sets up a counter for the multiplexer
    lab2_multiplexer #(
        .width     (24),
        .max_count (4_999_999)
    ) multiplex (
        .clk    (int_osc),
        .multi  (multi)
    );
    

endmodule