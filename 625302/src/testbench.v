`timescale 1ns/1ps
module tb_Vehicular_Emissions_FSM;
logic clk, reset;
logic [7:0] CO2_level;
logic warning, critical;

Vehicular_Emissions_FSM uut (
    .clk(clk), 
    .reset(reset), 
    .CO2_level(CO2_level), 
    .warning(warning), 
    .critical(critical)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("/output/simulation_output.vcd");
    $dumpvars(0, tb_Vehicular_Emissions_FSM);

    clk = 0; reset = 1; CO2_level = 0;
    #10 reset = 0;
    
    #10 CO2_level = 30; // Normal state
    #10 CO2_level = 70; // Warning state
    #10 CO2_level = 120; // Critical state
    #10 CO2_level = 40; // Back to Normal

    #20 $finish;
end

endmodule
