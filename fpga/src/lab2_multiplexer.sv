// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Multiplexer module that multiplexes two seven-segment displays

module lab2_multiplexer #(parameter width = 24, parameter logic [width-1:0] max_count = 4_999_999)(
    input  logic clk,
    output logic multi
);

logic [width-1:0] count = 0;
   // Blink state
   logic state = 0;

    // Counter
   always_ff @(posedge clk) begin
     if(reset == 0) begin
      count <= 0;
      state <= 0;
     end
     else if(enable) begin
      if(count == max_count) begin // Max count
        state <= ~state;
        count <= 0;
      end
      else count <= count + 1;
     end
   end

   // Assign LED output
   assign multi = state;



endmodule