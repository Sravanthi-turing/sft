`timescale 1ns / 1ps

module clockmultiplier #( 
    parameter MAX_MULTIPLIER = 4
)(
    input wire clk_in,
    input wire enable,
    input wire [$clog2(MAX_MULTIPLIER)-1:0] multiplier,
    output reg gated_clk // clock gating
);

    reg [$clog2(MAX_MULTIPLIER)-1:0] counter = 0;
    wire clk_generated;

    always @(posedge clk_in) begin
        if (counter >= (multiplier - 1))
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clk_generated = (counter == 0) ? 1'b1 : 1'b0;

    always @(posedge clk_in) begin
        if (enable)
            gated_clk <= clk_generated;
        else
            gated_clk <= 1'b0;
    end

endmodule
