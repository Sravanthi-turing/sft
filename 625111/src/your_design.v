module crossbar_switch #(parameter N = 4, M = 4)(
    input wire clk,
    input wire rst,
    input wire [N-1:0] req,
    input wire [M-1:0] dest[N-1:0],
    input wire [31:0] data_in[N-1:0],
    output reg [31:0] data_out[M-1:0],
    output reg [M-1:0] grant
);
    reg [M-1:0] security_filter[N-1:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 0;
            data_out <= '{default: 32'b0};
        end else begin
            integer i;
            for (i = 0; i < N; i = i + 1) begin
                if (req[i] && security_filter[i][dest[i]]) begin
                    grant[dest[i]] <= 1;
                    data_out[dest[i]] <= data_in[i];
                end else begin
                    grant[dest[i]] <= 0;
                end
            end
        end
    end
endmodule
