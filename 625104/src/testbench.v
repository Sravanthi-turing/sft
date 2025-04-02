
`timescale 1ns / 1ps

module tb_clockmultiplier;
    parameter MAX_MULTIPLIER = 4;
    reg clk_in;
    reg enable;
    reg [$clog2(MAX_MULTIPLIER)-1:0] multiplier;
    wire gated_clk; 
    
    clockmultiplier #(.MAX_MULTIPLIER(MAX_MULTIPLIER)) dut (
        .clk_in(clk_in),
        .enable(enable),
        .multiplier(multiplier),
        .gated_clk(gated_clk)
    );
    
    always #5 clk_in = ~clk_in;
    
    initial begin
        $dumpfile("output/simulation_output.vcd");
        $dumpvars(0, tb_clockmultiplier);
        clk_in = 0;
        enable = 1;
        multiplier = 2;
        
        #50 multiplier = 2;
        #50 multiplier = 3;
        #50 multiplier = 4;
        #50 enable = 0;
        #50 enable = 1;
        #50 multiplier = 1;
        #50 multiplier = MAX_MULTIPLIER;
        #50 enable = 0;
        #50 enable = 1;
        #50 multiplier = MAX_MULTIPLIER + 1;
        #50 $finish;
    end
endmodule
