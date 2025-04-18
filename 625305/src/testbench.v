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
            always #5 clk = ~clk;

        clk = 0;
        rst = 1;
        data_valid = 0;
        sensor_data = 0;
        #10 rst = 0;
        
        #10 data_valid = 1; sensor_data = 16'h20;
        #10 data_valid = 0;
        
        #20 data_valid = 1; sensor_data = 16'h80;
        #10 data_valid = 0;
        
        #20 data_valid = 1; sensor_data = 16'h00;
        #10 data_valid = 0;
        
        #20 data_valid = 1; sensor_data = 16'hFF;
        #10 data_valid = 0;
        
        #20 data_valid = 1; sensor_data = 16'h40;
        #10 sensor_data = 16'h50;
        #10 sensor_data = 16'h60;
        #10 data_valid = 0;
        
        #50 $finish;
    end

endmodule
