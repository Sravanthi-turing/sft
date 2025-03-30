module mimo_dsp #(parameter N = 4, DATA_WIDTH = 16)(
    input wire clk,
    input wire rst,
    input wire [N*DATA_WIDTH-1:0] data_in,
    output reg [N*DATA_WIDTH-1:0] data_out
);

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : DSP_UNITS
            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    data_out[i*DATA_WIDTH +: DATA_WIDTH] <= 0;
                end else begin
                    data_out[i*DATA_WIDTH +: DATA_WIDTH] <= data_in[i*DATA_WIDTH +: DATA_WIDTH] + 1;
                end
            end
        end
    endgenerate

endmodule
