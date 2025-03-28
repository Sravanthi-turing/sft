`timescale 1ns/1ps

module tb_mppt_controller;

    reg clk, rst_n;
    reg [15:0] v_in, i_in;
    wire [7:0] pwm_out;

    mppt_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .v_in(v_in),
        .i_in(i_in),
        .pwm_out(pwm_out)
    );

    // Clock Generation 
    always #5 clk = ~clk;

    initial begin
        //  VCD Dump
        $dumpfile("/output/simulation_output.vcd"); 
        $dumpvars(0, tb_mppt_controller);
        
        // Initialize signals
        clk = 0;
        rst_n = 0;
        v_in = 16'd1500; 
        i_in = 16'd500;  

        #20 rst_n = 1; 
        #50 v_in = 16'd1600; i_in = 16'd550;
        #50 v_in = 16'd1400; i_in = 16'd450;
        #50 v_in = 16'd1550; i_in = 16'd500;
        #50 v_in = 16'd1650; i_in = 16'd525;

       #50 v_in = 16'd1580; i_in = 16'd510;
        #50 v_in = 16'd1700; i_in = 16'd540;
        #50 v_in = 16'd1450; i_in = 16'd480;
        
        #100 $finish;
    end

endmodule
