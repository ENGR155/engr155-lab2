// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab2_keypad_skm (
    input  logic [3:0] cols, // Column inputs from the keypad
    output logic [3:0] rows, // Row outputs to the keypad
    output logic [3:0] led // LED outputs from the FPGA
);

    logic int_osc;
    logic [1:0] scan_out;

    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Sets up a counter for the scanner
    lab2_scanner #(
        .width     (24),
        .max_count (2_999_999)
    ) scan (
        .reset_n  (1'b1),
        .clk    (int_osc),
        .enable (1'b1),
        .out    (scan_out)
    );
    

    // Assign row data
    always_comb begin
        case(scan_out)
            3'b000: rows = 4'b1000; // Row 3 active
            3'b001: rows = 4'b0100; // Row 2 active
            3'b010: rows = 4'b0010; // Row 1 active
            3'b011: rows = 4'b0001; // Row 0 active
            default: rows = 4'b0000; // All rows inactive
        endcase
    end

    // Assigning final logic by reading from columns
    assign led = ~cols;
endmodule