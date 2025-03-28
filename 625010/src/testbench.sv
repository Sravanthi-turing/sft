`timescale 1ns/1ps

module testbench;
    reg a, b;
    wire y;

    // Instantiate the design under test (DUT)
    and_gate dut(.a(a), .b(b), .y(y));

    // Dump simulation output to VCD file
    initial begin
        $dumpfile("/output/simulation_output.vcd");
        $dumpvars(0, testbench);

        // Apply test cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        // End simulation
        $finish;
    end
endmodule
