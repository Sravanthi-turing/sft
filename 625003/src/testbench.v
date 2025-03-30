`timescale 1ns/1ps

module tb_bus_arbiter;
    parameter NUM_MASTERS = 4;
    reg clk, reset, config_wr;
    reg [NUM_MASTERS-1:0] req;
    wire [NUM_MASTERS-1:0] grant;
    reg [1:0] config_addr;
    reg [7:0] config_data;

    bus_arbiter #(.NUM_MASTERS(NUM_MASTERS)) uut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .grant(grant),
        .config_wr(config_wr),
        .config_addr(config_addr),
        .config_data(config_data)
    );

    initial begin
      $dumpfile("output/simulation_out.vcd");
        $dumpvars(0, tb_bus_arbiter);
        
        clk = 0;
        reset = 1;
        req = 4'b0000;
        config_wr = 0;
        config_addr = 2'b00;
        config_data = 8'b00000000;
        
        #10 reset = 0;
        
        // Test Case 1: Single request
        #5 req = 4'b0001;
        #10 req = 4'b0000;
        
        // Test Case 2: Multiple requests, round-robin arbitration
        #5 req = 4'b1010;
        #10 req = 4'b0101;
        
        // Test Case 3: Changing number of masters dynamically
        #10 config_wr = 1;
        config_addr = 2'b00;
        config_data = 8'b00000010;
        #5 config_wr = 0;
        
        // Test Case 4: Single master request after configuration change
        #10 req = 4'b0010;
        #10 req = 4'b1000;
        
        // Test Case 5: Reset behavior check
        #10 reset = 1;
        #10 reset = 0;
        req = 4'b1111;
        
        #50 $finish;
    end

    always #5 clk = ~clk;

endmodule
