`timescale 1ns/1ps

module tb_Vehicular_Emissions_FSM;
    reg clk, reset;
    reg [7:0] CO2_level;
    wire warning, critical;  
    
    // Instantiate the DUT (Device Under Test)
    Vehicular_Emissions_FSM uut (
        .clk(clk), 
        .reset(reset), 
        .CO2_level(CO2_level), 
        .warning(warning), 
        .critical(critical)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Test Scenario
    initial begin
        $dumpfile("/output/simulation_output.vcd");
        $dumpvars(0, tb_Vehicular_Emissions_FSM);

        clk = 0; reset = 1; CO2_level = 0;
        #10 reset = 0;
        
        #10 CO2_level = 30;  // Normal state
        #10 CO2_level = 70;  // Warning state
        #10 CO2_level = 120; // Critical state
        #10 CO2_level = 40;  // Back to Normal

        
        // Corner Cases
        #10 CO2_level = 99;  // Edge of Warning → Should remain in Warning
        #10 CO2_level = 100; // Edge of Critical → Should transition to Critical
        #10 CO2_level = 50;  // Edge of Normal → Should transition to Normal

        // Fluctuation (Error cases)
        #10 CO2_level = 49;  // Normal
        #10 CO2_level = 51;  // Warning (crossing threshold)
        #10 CO2_level = 49;  // Normal (should go back)

        #20 $finish;
    end
endmodule

