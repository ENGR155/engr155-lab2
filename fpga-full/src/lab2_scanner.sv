// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Used to be a counter to scan a keypad

module lab2_scanner #(parameter width = 24, parameter logic [width-1:0] max_count = 11_999_999)(// Params
     input  logic clk, // Clock input
     output logic [3:0] rows
 );

    logic [width-1:0] count2 = 0;
    logic [1:0] state = 0;

  // Sets up a counter for the multiplexer
  counter #(
      .width     (width),
      .max_count (max_count)
  ) count (
      .reset_n  (1'b1),
      .clk    (clk),
      .enable (1'b1),
      .count2  (count)
    );

  // Assigning final logic and switching
  always_comb begin
    if (count2 < max_count/4) 
        state = 2'b00;
    else if (count2 < max_count/2)
        state = 2'b01;
    else if (count2 < 3*max_count/4)
        state = 2'b10;
    else 
        state = 2'b11;
  end

  // Assign row data
    always_comb begin
        case(state)
            2'b00: rows = 4'b1000; // Row 0 active
            2'b01: rows = 4'b0100; // Row 1 active
            2'b10: rows = 4'b0010; // Row 2 active
            2'b11: rows = 4'b0001; // Row 3 active
            default: rows = 4'b0000; // All rows inactive
        endcase
    end

endmodule