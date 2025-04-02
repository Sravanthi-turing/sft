
`timescale 1ns / 1ps

module tb_MemoryArray;
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    reg clk;
    reg we;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    
    MemoryArray #(.MEM_TYPE("REG"), .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("output/simulation_output.vcd");
        $dumpvars(0, tb_MemoryArray);
        clk = 0;
        we = 0;
        addr = 0;
        din = 0;
        
        #10 we = 1; addr = 4'h1; din = 8'hAA;
        #10 we = 1; addr = 4'h2; din = 8'h55;
        #10 we = 0; addr = 4'h1;
        #10 we = 0; addr = 4'h2;
        
        #10 we = 1; addr = 4'hF; din = 8'hFF;
        #10 we = 0; addr = 4'hF;
        
        #10 we = 1; addr = 4'h0; din = 8'h00;
        #10 we = 0; addr = 4'h0;
        
        #10 we = 1; addr = 4'h3; din = 8'h33;
        #10 we = 1; addr = 4'h3; din = 8'h44;
        #10 we = 0; addr = 4'h3;
        
        #10 addr = 4'h10;
        
        #10 $finish;
    end
endmodule
