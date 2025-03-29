`timescale 1ns/1ps

module scalable_data_structure_tb;

  logic clk;
  logic rst_n;
  logic push, pop;
  int   id;
  bit [127:0] src, dest;
  bit [127:0] payload;
  logic empty, full;
  int out_id;
  bit [127:0] out_src, out_dest;
  bit [127:0] out_payload;

  // Instantiate the DUT
  scalable_data_structure dut (
      .clk(clk),
      .rst_n(rst_n),
      .push(push),
      .pop(pop),
      .id(id),
      .src(src),
      .dest(dest),
      .payload(payload),
      .empty(empty),
      .full(full),
      .out_id(out_id),
      .out_src(out_src),
      .out_dest(out_dest),
      .out_payload(out_payload)
  );

  // Clock generation
  always #5 clk = ~clk;  
  
  initial begin
      $dumpfile("/output/simulation_output.vcd");  
      $dumpvars(0, scalable_data_structure_tb);

      // Reset sequence
      clk = 0;
      rst_n = 0;
      push = 0;
      pop = 0;
      #20;
      rst_n = 1;

      // Test case: Push packets into FIFO
      for (int i = 0; i < 1000; i++) begin
          push = 1;
          id = i;
          src = i % 100;  // Encoding source as an integer in 128-bit format
          dest = (i + 1) % 10;
          payload = $random;
          #10;
      end
      push = 0;

      // Check if FIFO is full
      if (full)
          $display("[INFO] FIFO is full!");

      // Test case: Pop packets and verify order
      for (int i = 0; i < 1000; i++) begin
          pop = 1;
          #10;
          pop = 0;

          // Validate FIFO behavior
          if (out_id !== i) begin
              $display("[ERROR] Mismatch! Expected ID: %0d, Found: %0d", i, out_id);
              $stop;
          end
      end

      // Check if FIFO is empty
      if (empty)
          $display("[INFO] FIFO is empty after all packets processed!");

      $display("===== TEST PASSED: Scalable Data Structure Works Correctly =====");
      
      #50;
      $finish;
  end

endmodule
