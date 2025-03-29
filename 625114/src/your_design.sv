`timescale 1ns/1ps

module dtt_crossbar_switch #(
    parameter N_IN = 4,
    parameter N_OUT = 4,
    parameter DATA_WIDTH = 32,
    parameter DEST_WIDTH = $clog2(N_OUT)
)(
    input logic clk,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] in_data [N_IN],
    input logic [DEST_WIDTH-1:0] in_dest [N_IN],
    input logic in_valid [N_IN],
    output logic [DATA_WIDTH-1:0] out_data [N_OUT],
    output logic out_valid [N_OUT]
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < N_OUT; i++) begin
                out_data[i]  <= 0;
                out_valid[i] <= 0;
            end
        end else begin
            for (int i = 0; i < N_OUT; i++) begin
                out_valid[i] <= 0;
            end
            for (int i = 0; i < N_IN; i++) begin
                if (in_valid[i]) begin
                    out_data[in_dest[i]]  <= in_data[i];
                    out_valid[in_dest[i]] <= 1;
                end
            end
        end
    end

endmodule
