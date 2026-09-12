// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab2_skm #(parameter width = 24, parameter [width-1:0] max_count = 2999999) (
    input  logic [3:0] cols, // Column inputs from the keypad
    output logic [3:0] rows, // Row outputs to the keypad
    output logic [3:0] led // LED outputs from the FPGA
);

    logic int_osc;

    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Sets up a counter for the scanner
    lab2_scanner #(
        .width     (24),
        .max_count (2_999_999)
    ) scan (
        .reset  (1'b1),
        .clk    (int_osc),
        .row    (rows)
    );
    
    // Assigning final logic by reading from columns
    assign led[0] = cols[0];
    assign led[1] = cols[1];
    assign led[2] = cols[2];
    assign led[3] = cols[3];

endmodule