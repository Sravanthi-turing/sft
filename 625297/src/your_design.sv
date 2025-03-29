`timescale 1ns/1ps

module scalable_data_structure (
    input  logic        clk,         
    input  logic        rst_n,       
    input  logic        push,        
    input  logic        pop,         
    input  int          id,          
    input  bit [127:0]  src,         
    input  bit [127:0]  dest,        
    input  bit [127:0]  payload,     
    output logic        empty,       
    output logic        full,        
    output int          out_id,      
    output bit [127:0]  out_src,     
    output bit [127:0]  out_dest,    
    output bit [127:0]  out_payload  
);

  // FIFO Parameters
  localparam int DEPTH = 1024;
  int queue_id[DEPTH];
  bit [127:0] queue_src[DEPTH];
  bit [127:0] queue_dest[DEPTH];
  bit [127:0] queue_payload[DEPTH];

  int read_pointer = 0;
  int write_pointer = 0;
  int count = 0;

  always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          read_pointer <= 0;
          write_pointer <= 0;
          count <= 0;
      end else begin
          // Push packet into FIFO
          if (push && !full) begin
              queue_id[write_pointer] <= id;
              queue_src[write_pointer] <= src;
              queue_dest[write_pointer] <= dest;
              queue_payload[write_pointer] <= payload;
              write_pointer <= (write_pointer + 1) % DEPTH;
              count <= count + 1;
          end
          
          // Pop packet from FIFO
          if (pop && !empty) begin
              out_id      <= queue_id[read_pointer];
              out_src     <= queue_src[read_pointer];
              out_dest    <= queue_dest[read_pointer];
              out_payload <= queue_payload[read_pointer];
              read_pointer <= (read_pointer + 1) % DEPTH;
              count <= count - 1;
          end
      end
  end

  // Queue status signals
  assign empty = (count == 0);
  assign full  = (count == DEPTH);

endmodule
