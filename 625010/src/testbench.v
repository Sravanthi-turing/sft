`timescale 1ns/1ps

module high_speed_bus_interface_tb;

    // Signals
    logic        clk;
    logic        rst_n;
    logic        valid_in;
    logic [31:0] data_in;
    logic        valid_out;
    logic [31:0] data_out;
    logic        error_detected;
    logic        error_corrected;

    // Instantiate DUT (Device Under Test)
    high_speed_bus_interface dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in(data_in),
        .valid_out(valid_out),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Dump File Setup
    initial begin
        $dumpfile("high_speed_bus_interface_tb.vcd");
        $dumpvars(0, high_speed_bus_interface_tb);
    end

    // Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        valid_in = 0;
        data_in = 0;
        #20 rst_n = 1; // Release reset

        // Test Case 1: Normal Data Transfer (No Error)
        valid_in = 1;
        data_in = 32'hA5A5A5A5;
        #10 valid_in = 0;
        #20;
        assert (error_detected == 0) else $error("Test Case 1 Failed: Error detected unexpectedly!");

        // Test Case 2: Inject Single Bit Error (Bit 5 Flipped)
        valid_in = 1;
        data_in = 32'hFFFFFFFF; // Send known pattern
        #10 valid_in = 0;
        #10;
        data_out[5] = ~data_out[5]; // Manually flip bit 5
        #10;
        assert (error_corrected == 1) else $error("Test Case 2 Failed: Single-bit error not corrected!");

        // Test Case 3: Inject Single Bit Error (Bit 15 Flipped)
        valid_in = 1;
        data_in = 32'h12345678;
        #10 valid_in = 0;
        #10;
        data_out[15] = ~data_out[15]; // Manually flip bit 15
        #10;
        assert (error_corrected == 1) else $error("Test Case 3 Failed: Single-bit error not corrected!");

        // Test Case 4: Inject Double Bit Error (Bits 2 and 10 Flipped)
        valid_in = 1;
        data_in = 32'h98765432;
        #10 valid_in = 0;
        #10;
        data_out[2] = ~data_out[2]; // Flip bit 2
        data_out[10] = ~data_out[10]; // Flip bit 10
        #10;
        assert (error_detected == 1 && error_corrected == 0) else $error("Test Case 4 Failed: Double-bit error not flagged!");

        // Test Case 5: Random Data Transfer
        valid_in = 1;
        data_in = $random;
        #10 valid_in = 0;
        #20;
        assert (error_detected == 0) else $error("Test Case 5 Failed: Unexpected error detected!");

        // End Simulation
        #50;
        $display("All Test Cases Passed!");
        $finish;
    end

endmodule
