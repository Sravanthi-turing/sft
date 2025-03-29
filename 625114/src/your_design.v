`timescale 1ns/1ps

module dtt_crossbar_switch #(
    parameter N_IN = 4,  // input ports
    parameter N_OUT = 4, // output ports
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst_n,
    
    input logic [DATA_WIDTH-1:0] in_data [N_IN],
    input logic [N_OUT-1:0] in_dest [N_IN],  
    input logic in_valid [N_IN],
    
    output logic [DATA_WIDTH-1:0] out_data [N_OUT],
    output logic out_valid [N_OUT]
);

logic [DATA_WIDTH-1:0] buffer [N_IN][N_OUT];
int queue_size [N_OUT];  

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < N_OUT; i++) begin
            queue_size[i] <= 0;
            out_valid[i] <= 0;
        end
    end else begin
        for (int i = 0; i < N_IN; i++) begin
            if (in_valid[i]) begin
                int selected_out = in_dest[i];  
                if (queue_size[selected_out] < N_IN) begin
                    buffer[i][selected_out] <= in_data[i];
                    queue_size[selected_out] <= queue_size[selected_out] + 1;
                    out_valid[selected_out] <= 1;
                end
            end
        end

        for (int j = 0; j < N_OUT; j++) begin
            if (queue_size[j] > 0) begin
                out_data[j] <= buffer[queue_size[j]-1][j];
                queue_size[j] <= queue_size[j] - 1;
            end else begin
                out_valid[j] <= 0;
            end
        end
    end
end

endmodule
