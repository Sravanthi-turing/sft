`timescale 1ns/1ps

module scalable_data_structure (
    input  logic        clk,         
    input  logic        rst_n,       
    input  logic        pop,         
    input  int          id,          
    input  string       src,         
    input  string       dest,        
    input  bit [127:0]  payload,     
    output logic        empty,       
    output logic        full,        
    output int          out_id,      
    output string       out_src,     
    output string       out_dest,    
    output bit [127:0]  out_payload  
);

  // Define struct for packet storage
  typedef struct {
      int id;
      string src;
      string dest;
      bit [127:0] payload;  
  } packet_t;

  // Dynamic queue for packet storage
  packet_t packet_queue[$];

  always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          packet_queue = {};  // Clear queue on reset
      end else begin
          // Push packet into the queue
          if (push) begin
              packet_queue.push_back('{id, src, dest, payload});
          end
          
          // Pop packet from the queue
          if (pop && !packet_queue.empty()) begin
              packet_t pkt = packet_queue.pop_front();
              out_id      = pkt.id;
              out_src     = pkt.src;
              out_dest    = pkt.dest;
              out_payload = pkt.payload;
          end
      end
  end

  // Queue status signals
  assign empty = (packet_queue.size() == 0);
  assign full  = (packet_queue.size() >= 1024);  

endmodule
