`timescale 1ns/1ns

// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 13, 2026
// Tests the top-level wiring, anode, and LED outputs

module lab2_skm_tb();

    // These signals connect to the inputs and outputs of the top-level module.
    logic [3:0] cols; // Column inputs from the keypad
    logic [3:0] s;
    logic [3:0] s_2;
    logic [6:0] seg;
    logic [1:0] anode; // Pinout for common anode 
    logic [3:0] rows; // Row outputs to the keypad
    logic [3:0] led; // LED outputs from the FPGA

    // Instantiate the top-level design being tested.
    // A small max_count is used to make the counter change quickly during sim
    lab2_skm #(
    .max_count1 (24'd3),
    .max_count2 (24'd15)
    ) dut (
        .cols  (cols),
        .s     (s),
        .s_2   (s_2),
        .seg   (seg),
        .anode (anode),
        .rows  (rows),
        .led   (led)
    );

    initial begin
    // Defined initial input conditions
        cols = 4'b1111;  // No keypad buttons pressed
        s    = 4'd0;
        s_2  = 4'd8;

        #1;

            // No columns active: all LEDs off
    cols = 4'b1111;
    #1;
    assert (led === 4'b0000)
        $display("PASSED: no pressed columns.");
    else
        $error("FAILED: expected led=0000, received %04b.", led);

    // One column pulled low
    cols = 4'b1011;
    #1;
    assert (led === 4'b0100)
        $display("PASSED: one column activated.");
    else
        $error("FAILED: expected led=0100, received %04b.", led);

    // Two columns pulled low simultaneously
    cols = 4'b1001;
    #1;
    assert (led === 4'b0110)
        $display("PASSED: two columns activated.");
    else
        $error("FAILED: expected led=0110, received %04b.", led);

    // Checking if multiplexing works
    wait (anode === 2'b10);
    #1;
    assert (seg === 7'b1000000)
        $display("PASSED: first display shows s.");
    else
        $error("FAILED: first display has seg=%07b.", seg);

    wait (anode === 2'b01);
    #1;
    assert (seg === 7'b0000000)
        $display("PASSED: second display shows s_2.");
    else
        $error("FAILED: second display has seg=%07b.", seg);
    
    // Checking if rows work
    wait (rows === 4'b1000);
    wait (rows === 4'b0100);
    wait (rows === 4'b0010);
    wait (rows === 4'b0001);

    $display("PASSED: scanner produced all four row states.");

    // Finished
    $display("All top-level tests completed.");
    $finish;
end

// If the oscillator or simulation gets stuck, stop the testbench after 1000 ns and report an error
initial begin
   #1000;
    $fatal(1, "FAILED! Top-level simulation timed out.");
end


endmodule