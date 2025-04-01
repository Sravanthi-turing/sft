
module cache #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 128, CACHE_SIZE = 1024) (
  input logic clk,
  input logic reset,
  input logic read_en,
  input logic write_en,
  input logic [ADDR_WIDTH-1:0] addr,
  input logic [DATA_WIDTH-1:0] write_data,
  output logic [DATA_WIDTH-1:0] read_data,
  output logic hit
);
  
  typedef struct packed {
    logic valid;
    logic [ADDR_WIDTH-1:0] tag;
    logic [DATA_WIDTH-1:0] data;
  } cache_line_t;
  
  cache_line_t cache_mem [CACHE_SIZE];
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      for (int i = 0; i < CACHE_SIZE; i++) begin
        cache_mem[i].valid <= 0;
      end
    end else if (write_en) begin
      cache_mem[$unsigned(addr) % CACHE_SIZE].valid <= 1;
      cache_mem[$unsigned(addr) % CACHE_SIZE].tag <= addr;
      cache_mem[$unsigned(addr) % CACHE_SIZE].data <= write_data;
    end
  end
  
  always_ff @(posedge clk) begin
    hit <= 0;
    if (read_en) begin
      if (cache_mem[$unsigned(addr) % CACHE_SIZE].valid && cache_mem[$unsigned(addr) % CACHE_SIZE].tag == addr) begin
        hit <= 1;
        read_data <= cache_mem[$unsigned(addr) % CACHE_SIZE].data;
      end else begin
        read_data <= '0;
      end
    end
  end
endmodule
