`timescale 1ns/1ps


module tb_mimo_dsp;
    parameter N = 4;
    parameter DATA_WIDTH = 16;
    reg clk, rst;
    reg [N*DATA_WIDTH-1:0] data_in;
    wire [N*DATA_WIDTH-1:0] data_out;

    mimo_dsp #(.N(N), .DATA_WIDTH(DATA_WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("output/simulation_out.vcd");
        $dumpvars(0, tb_mimo_dsp);
        clk = 0;
        rst = 1;
        data_in = {16'h0001, 16'h0002, 16'h0003, 16'h0004};
        #10 rst = 0;
        
        #10 data_in = {16'h0010, 16'h0020, 16'h0030, 16'h0040};
        #10 data_in = {16'h0A0A, 16'h0B0B, 16'h0C0C, 16'h0D0D};
        #20;
        
        $finish;
    end

    always @(posedge clk) begin
        $display("Time: %0t | Data In: %h | Data Out: %h", $time, data_in, data_out);
    end
endmodule
