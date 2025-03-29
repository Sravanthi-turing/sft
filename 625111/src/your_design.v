module crossbar_switch #(parameter N = 4, M = 4)(
    input wire clk,
    input wire rst,
    input wire [N-1:0] req,
    input wire [M*2-1:0] dest,
    input wire [N*32-1:0] data_in,
    output reg [M*32-1:0] data_out,
    output reg [M-1:0] grant
);
    reg [M-1:0] security_filter[N-1:0];

    always @(posedge clk or posedge rst) begin
        integer i;
        if (rst) begin
            grant <= 0;
            data_out <= 0;
            for (i = 0; i < N; i = i + 1) begin
                security_filter[i] <= {M{1'b1}};
            end
        end else begin
            for (i = 0; i < N; i = i + 1) begin
                if (req[i] && security_filter[i][dest[i*2 +: 2]]) begin
                    grant[dest[i*2 +: 2]] <= 1;
                    data_out[dest[i*2 +: 2]*32 +: 32] <= data_in[i*32 +: 32];
                end else begin
                    grant[dest[i*2 +: 2]] <= 0;
                end
            end
        end
    end
endmodule
