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

    dtt_crossbar_switch #(
        .N_IN(N_IN), 
        .N_OUT(N_OUT), 
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(in_data),   
        .in_dest(in_dest),
        .in_valid(in_valid),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("simulation_output.vcd");  
        $dumpvars(0, dtt_crossbar_switch_tb);
        
        clk = 0;
        rst_n = 0;
        for (int i = 0; i < N_IN; i++) begin
            in_data[i] = 0;
            in_dest[i] = 0;
            in_valid[i] = 0;
        end
        
        #20 rst_n = 1;  

        #10;
        in_data[0] = 32'hAAAA_BBBB; in_dest[0] = 2; in_valid[0] = 1;
        in_data[1] = 32'hCCCC_DDDD; in_dest[1] = 2; in_valid[1] = 1;
        in_data[2] = 32'hEEEE_FFFF; in_dest[2] = 1; in_valid[2] = 1;
        in_data[3] = 32'h1111_2222; in_dest[3] = 3; in_valid[3] = 1;

        #10;
        for (int i = 0; i < N_IN; i++) begin
            in_valid[i] = 0;
        end

        #50;
        $display("\n==== Crossbar Switch Output ====");
        for (int j = 0; j < N_OUT; j++) begin
            if (out_valid[j]) begin
                $display("Output [%0d]: Data = %h", j, out_data[j]);
            end
        end

        #50;
        $finish;
    end
endmodule
