// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab2_skm #(parameter width = 24, parameter [width-1:0] max_count = 4999999) (
    input  logic [3:0] cols, // Column inputs from the keypad
    input  logic [3:0] s,
    input  logic [3:0] s_2,
    output logic [6:0] seg,
    output logic [1:0] anode // Pinout for common anode for the transistors
    output logic [3:0] rows, // Row outputs to the keypad
    output logic [3:0] led // LED outputs from the FPGA
);

    logic int_osc;
    logic counter;
    logic multi; // For multiplexing the two seven-segment displays
    logic [1:0] state; // State variable for the keypad

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
    counter #(
        .width     (24),
        .max_count (199_999)
    ) count (
        .reset_n  (1'b1),
        .clk    (int_osc),
        .enable (1'b1),
        .count2  (counter)
    );
    
    // Assigning final logic and switching
    if counter > max_count/2 begin
        multi = 1;
    else
        multi = 0;
    end

    if counter < max_count/4 begin
        state = 2'b00;
    else if counter < max_count/2 
        state = 2'b01;
    else if counter < 3*max_count/4
        state = 2'b10;
    else
        state = 2'b11;
    end

    assign s_1 = multi ? s_2 : s;

    assign anode[0] = multi;
    assign anode[1] = ~multi;   

    // Assign row data
    always_comb begin
        case(state)
            2'b00: rows = 4'b1000; // Row 0 active
            2'b01: rows = 4'b0100; // Row 1 active
            2'b10: rows = 4'b0010; // Row 2 active
            2'b11: rows = 4'b0001; // Row 3 active
            default: rows = 4'b1111; // All rows inactive
        endcase
    end

    // Assigning final logic by reading from columns
    assign led[0] = cols[0];
    assign led[1] = cols[1];
    assign led[2] = cols[2];
    assign led[3] = cols[3];


endmodule