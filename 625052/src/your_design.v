module LowPowerArthemic #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [1:0] op,
    output reg  [2*WIDTH-1:0] result
);

wire [WIDTH-1:0] a_gated, b_gated; 

assign a_gated = (op != 2'b11) ? a : {WIDTH{1'b0}};
assign b_gated = (op != 2'b11) ? b : {WIDTH{1'b0}};

function [2*WIDTH-1:0] multiply;
    input [WIDTH-1:0] x, y;
    integer i;
    begin
        multiply = 0;
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (y[i])
                multiply = multiply + (x << i);
        end
    end
endfunction

always @(*) begin
    case (op)
        2'b00: result = a_gated + b_gated;
        2'b01: result = a_gated - b_gated;
        2'b10: result = multiply(a_gated, b_gated);
        default: result = {2*WIDTH{1'b0}};
    endcase
end

endmodule

