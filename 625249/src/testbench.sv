`timescale 1ns/1ps

module cache_testbench;
  
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 128;
  parameter CACHE_SIZE = 1024;
  
  logic clk;
  logic reset;
  logic read_en;
  logic write_en;
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] write_data;
  logic [DATA_WIDTH-1:0] read_data;
  logic hit;
  
  cache #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CACHE_SIZE(CACHE_SIZE)) DUT (
    .clk(clk),
    .reset(reset),
    .read_en(read_en),
    .write_en(write_en),
    .addr(addr),
    .write_data(write_data),
    .read_data(read_data),
    .hit(hit)
  );
  
  always #5 clk = ~clk;
  
  int total_accesses = 0;
  int cache_hits = 0;
  int cache_misses = 0;
  
  initial begin
    $dumpfile("output/simulation_output.vcd");
    $dumpvars(0, cache_testbench);
    clk = 0;
    reset = 1;
    read_en = 0;
    write_en = 0;
    addr = 0;
    write_data = 0;
    
    #10 reset = 0;
    
    for (int i = 0; i < 16; i++) begin
      addr = i;
      write_data = i * 10;
      write_en = 1;
      #10;
      write_en = 0;
    end
    
    for (int i = 0; i < 32; i++) begin
      addr = i;
      read_en = 1;
      #10;
      read_en = 0;
      total_accesses++;
      if (hit) cache_hits++;
      else cache_misses++;
    end
    
    $display("Total Cache Accesses: %d", total_accesses);
    $display("Cache Hits: %d", cache_hits);
    $display("Cache Misses: %d", cache_misses);
    $display("Hit Ratio: %.2f%%", (cache_hits * 100.0) / total_accesses);
    
    #50;
    $stop;
  end
  
endmodule
