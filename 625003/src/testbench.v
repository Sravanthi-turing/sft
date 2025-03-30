`timescale 1ns/1ps

module tb_bus_arbiter();

    reg clk, reset;
    reg [3:0] req;
    wire [3:0] grant;
    reg config_wr;
    reg [1:0] config_addr;
    reg [7:0] config_data;

    bus_arbiter #(.NUM_MASTERS(4)) uut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .grant(grant),
        .config_wr(config_wr),
        .config_addr(config_addr),
        .config_data(config_data)
    );

    initial begin
        $dumpfile("simulation_out.vcd");
        $dumpvars(0, tb_bus_arbiter);
        
        clk = 0;
        reset = 1;
        req = 4'b0000;
        config_wr = 0;
        config_addr = 0;
        config_data = 0;

        #10 reset = 0;

        #10 req = 4'b0001; 
        #10 req = 4'b0000;

        #10 req = 4'b0110; 
        #10 req = 4'b0000;

        #10 config_wr = 1; config_addr = 2'b00; config_data = 2'b10;
        #10 config_wr = 0;

        #10 req = 4'b0001; 
        #10 req = 4'b0010;
        #10 req = 4'b0000;

        #50 $finish;
    end

    always #5 clk = ~clk;

endmodule
