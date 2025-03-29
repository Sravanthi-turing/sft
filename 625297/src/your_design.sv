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

  // Dynamic queues for each field
  int id_queue[$];
  bit [127:0] src_queue[$];
  bit [127:0] dest_queue[$];
  bit [127:0] payload_queue[$];

  always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          id_queue      = {};
          src_queue     = {};
          dest_queue    = {};
          payload_queue = {};
      end else begin
          // Push packet into queues
          if (push) begin
              id_queue.push_back(id);
              src_queue.push_back(src);
              dest_queue.push_back(dest);
              payload_queue.push_back(payload);
          end
          
          // Pop packet from queues
          if (pop && !id_queue.empty()) begin
              out_id      = id_queue.pop_front();
              out_src     = src_queue.pop_front();
              out_dest    = dest_queue.pop_front();
              out_payload = payload_queue.pop_front();
          end
      end
  end

  // Queue status signals
  assign empty = (id_queue.size() == 0);
  assign full  = (id_queue.size() >= 1024);

endmodule
