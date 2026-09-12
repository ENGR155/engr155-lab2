// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Multiplexer module that multiplexes two seven-segment displays

module lab2_multiplexer #(parameter width = 24, parameter logic [width-1:0] max_count = 2_999_999)(
    input  logic reset, clk,
    output logic [3:0] row);

logic [3:0] state, nextstate;
parameter S0 = 4'b1000, S1 = 4'b0100, S2 = 4'b0010, S3 = 4'b0001; // In order row[3], row[2], row[1], row[0]



logic [width-1:0] count = 0;
   // Blink state
   logic state = 0;
    // Counter
   always_ff @(posedge clk) begin
     if(reset == 0) begin
      count <= 0;
      state <= S0;
     end
     else begin
      if(count == max_count) begin // Max count
        state <= nextstate;
        count <= 0;
      end
      else count <= count + 1;
     end
   end

// Next state logic
always_comb begin
    case(state)
        S0: nextstate = S1;
        S1: nextstate = S2;
        S2: nextstate = S3;
        S3: nextstate = S0;
        default: nextstate = S0;
    endcase
end

// Output Logic
assign row[3:0] = state;

endmodule