`timescale 1ns/1ps

module dtt_crossbar_switch_tb;
    parameter N_IN = 4;
    parameter N_OUT = 4;
    parameter DATA_WIDTH = 32;
    parameter DEST_WIDTH = $clog2(N_OUT);

    logic clk;
    logic rst_n;

    logic [DATA_WIDTH-1:0] in_data [N_IN];
    logic [DEST_WIDTH-1:0] in_dest [N_IN];  
    logic in_valid [N_IN];

    logic [DATA_WIDTH-1:0] out_data [N_OUT];
    logic out_valid [N_OUT];

    logic [N_IN*DATA_WIDTH-1:0] flat_in_data;
    logic [N_IN*DEST_WIDTH-1:0] flat_in_dest;
    logic [N_IN-1:0] flat_in_valid;

    logic [N_OUT*DATA_WIDTH-1:0] flat_out_data;
    logic [N_OUT-1:0] flat_out_valid;

    dtt_crossbar_switch #(
        .N_IN(N_IN), 
        .N_OUT(N_OUT), 
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(flat_in_data),
        .in_dest(flat_in_dest),
        .in_valid(flat_in_valid),
        .out_data(flat_out_data),
        .out_valid(flat_out_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("/output/simulation_output.vcd");  
        $dumpvars(0, dtt_crossbar_switch_tb);
        
        // Initialize signals
        clk = 0;
        rst_n = 0;
        for (int i = 0; i < N_IN; i++) begin
            in_data[i] = 0;
            in_dest[i] = 0;
            in_valid[i] = 0;
        end
        
        #20 rst_n = 1;  // Release reset

        // Assign test vectors
        #10;
        in_data[0] = 32'hAAAA_BBBB; in_dest[0] = 2; in_valid[0] = 1;
        in_data[1] = 32'hCCCC_DDDD; in_dest[1] = 2; in_valid[1] = 1;
        in_data[2] = 32'hEEEE_FFFF; in_dest[2] = 1; in_valid[2] = 1;
        in_data[3] = 32'h1111_2222; in_dest[3] = 3; in_valid[3] = 1;

        flat_in_data = {in_data[3], in_data[2], in_data[1], in_data[0]};
        flat_in_dest = {in_dest[3], in_dest[2], in_dest[1], in_dest[0]};
        flat_in_valid = {in_valid[3], in_valid[2], in_valid[1], in_valid[0]};
        
        #10;
        for (int i = 0; i < N_IN; i++) begin
            in_valid[i] = 0;
        end

        #50;
        $display("\n==== Crossbar Switch Output ====");
        for (int j = 0; j < N_OUT; j++) begin
            if (flat_out_valid[j]) begin
                $display("Output [%0d]: Data = %h", j, flat_out_data[j * DATA_WIDTH +: DATA_WIDTH]);
            end
        end

        #50;
        $finish;
    end
endmodule
