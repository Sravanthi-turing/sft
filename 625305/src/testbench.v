
// Testbench
`timescale 1ns / 1ps
module tb_SensorInterface;
    reg clk, rst, data_valid;
    reg [15:0] sensor_data;
    wire [15:0] processed_data;
    wire decision;

    SensorInterface uut (
        .clk(clk),
        .rst(rst),
        .sensor_data(sensor_data),
        .data_valid(data_valid),
        .processed_data(processed_data),
        .decision(decision)
    );

    initial begin
        $dumpfile("output/simulation_output.vcd");
      $dumpvars(0, tb_SensorInterface);
        
        clk = 0;
        rst = 1;
        data_valid = 0;
        sensor_data = 0;
        #10 rst = 0;
        
        // Test Case 1: Normal sensor data input
        #10 data_valid = 1; sensor_data = 16'h20;
        #10 data_valid = 0;
        
        // Test Case 2: Edge case - sensor data near threshold
        #20 data_valid = 1; sensor_data = 16'h80;
        #10 data_valid = 0;
        
        // Test Case 3: Extreme low value
        #20 data_valid = 1; sensor_data = 16'h00;
        #10 data_valid = 0;
        
        // Test Case 4: Extreme high value
        #20 data_valid = 1; sensor_data = 16'hFF;
        #10 data_valid = 0;
        
        // Test Case 5: Continuous valid data
        #20 data_valid = 1; sensor_data = 16'h40;
        #10 sensor_data = 16'h50;
        #10 sensor_data = 16'h60;
        #10 data_valid = 0;
        
        #50 $finish;
    end

    always #5 clk = ~clk;
endmodule
