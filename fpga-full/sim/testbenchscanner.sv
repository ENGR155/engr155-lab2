`timescale 1ns/1ns

// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 13, 2026
// Tests the scanner module

// Tests the keypad scanning module
module lab2_scanner_tb();

    logic       clk;
    logic [3:0] rows;

    // Use a smaller counter
    lab2_scanner #(
        .width     (4),
        .max_count (4'd15)
    ) dut (
        .clk  (clk),
        .rows (rows)
    );

    // Generate a clock with a 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test the row-scanning sequence
    initial begin
        // Allow initial combinational signals to settle
        #1;

        // The scanner should begin on the first row
        assert (rows === 4'b1000)
            $display("PASSED: initial rows=1000.");
        else
            $fatal(1, "FAILED: expected rows=1000, received %04b.", rows);

        // Wait for the next change and check each row
        @(rows);
        #1;
        assert (rows === 4'b0100)
            $display("PASSED: rows changed to 0100.");
        else
            $fatal(1, "FAILED: expected rows=0100, received %04b.", rows);

        @(rows);
        #1;
        assert (rows === 4'b0010)
            $display("PASSED: rows changed to 0010.");
        else
            $fatal(1, "FAILED: expected rows=0010, received %04b.", rows);

        @(rows);
        #1;
        assert (rows === 4'b0001)
            $display("PASSED: rows changed to 0001.");
        else
            $fatal(1, "FAILED: expected rows=0001, received %04b.", rows);

        // Check that the scanner wraps back to the beginning
        @(rows);
        #1;
        assert (rows === 4'b1000)
            $display("PASSED: scanner wrapped back to 1000.");
        else
            $fatal(1, "FAILED: expected rows=1000, received %04b.", rows);

        $display("All scanner tests completed successfully.");
        $finish;
    end

// If the oscillator or simulation gets stuck, stop the testbench after 1000 ns and report an error
initial begin
   #1000;
    $fatal(1, "FAILED! Top-level simulation timed out.");
end

endmodule