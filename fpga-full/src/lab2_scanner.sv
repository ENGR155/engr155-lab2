// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Used to be a counter to scan a keypad

module lab2_scanner #(parameter width = 24, parameter logic [width-1:0] max_count = 2_999_999)( // Params
     input logic reset_n, clk, enable,
     output logic [1:0] out
 );

logic [width-1:0] count = 0;
logic [1:0] state = 0;

    // Counter
   always_ff @(posedge clk) begin
     if(reset_n == 0) begin
      count <= 0;
      state <= 0;
     end
     else if(enable) begin
      if(count == max_count) begin // Max count
        count <= 0;
        state <= state + 1;
        if (state == 3) state <= 0;
      end
      else count <= count + 1;
     end
   end

   // Assign LED output
   assign out = state;

endmodule