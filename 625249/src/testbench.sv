module ai_cache_testbench;
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

  ai_cache #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CACHE_SIZE(CACHE_SIZE)) DUT (
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
    $dumpfile("ai_cache_testbench.vcd");
    $dumpvars(0, ai_cache_testbench);

    clk = 0;
    reset = 1;
    read_en = 0;
    write_en = 0;
    addr = 0;
    write_data = 0;

    #10 reset = 0;
    #10 reset = 1;

    for (int i = 0; i < 8; i++) begin
      addr = i;
      write_data = i * 10;
      write_en = 1;
      #10;
      write_en = 0;
    end

    for (int i = 0; i < 8; i++) begin
      addr = i;
      read_en = 1;
      #10;
      read_en = 0;
      total_accesses++;
      if (hit) cache_hits++;
      else cache_misses++;
    end

    addr = 10; write_data = 100; write_en = 1;
    #10;
    write_en = 0;
    addr = 20; write_data = 200; write_en = 1;
    #10;
    write_en = 0;

    addr = 10; read_en = 1;
    #10;
    read_en = 0;
    addr = 20; read_en = 1;
    #10;
    read_en = 0;

    addr = 30; read_en = 1;
    #10;
    read_en = 0;
    total_accesses++;
    if (hit) cache_hits++;
    else cache_misses++;

    addr = 0; write_data = 1234; write_en = 1;
    #10;
    write_en = 0;
    addr = 0; read_en = 1;
    #10;
    read_en = 0;

    addr = 8; write_data = 4321; write_en = 1;
    #10;
    write_en = 0;

    addr = 8; read_en = 1;
    #10;
    read_en = 0;

    addr = 1000; write_data = 9999; write_en = 1;
    #10;
    write_en = 0;
    addr = 1000; read_en = 1;
    #10;
    read_en = 0;
    total_accesses++;
    if (hit) cache_hits++;
    else cache_misses++;

    $display("Total Cache Accesses: %d", total_accesses);
    $display("Cache Hits: %d", cache_hits);
    $display("Cache Misses: %d", cache_misses);
    $display("Hit Ratio: %.2f%%", (cache_hits * 100.0) / total_accesses);

    #50;
    $stop;
  end
endmodule
