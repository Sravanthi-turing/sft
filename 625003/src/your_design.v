`timescale 1ns/1ps

module bus_arbiter #(
    parameter NUM_MASTERS = 4,
    parameter DATA_WIDTH  = 32
)(
    input  wire                     clk,
    input  wire                     reset,
    input  wire [NUM_MASTERS-1:0]   req,
    output reg  [NUM_MASTERS-1:0]   grant,
    input  wire                     config_wr,
    input  wire [1:0]               config_addr,
    input  wire [7:0]               config_data
);

    reg [1:0] num_masters;
    reg [4:0] arb_counter;
    integer i;

    
always @(posedge clk or posedge reset) begin
    if (reset) begin
        num_masters <= NUM_MASTERS;
        arb_counter <= 0;
        grant <= 0;
    end else if (config_wr) begin
        case (config_addr)
            2'b00: num_masters <= config_data[1:0];
        endcase
    end else begin
        reg [NUM_MASTERS-1:0] temp_grant;
        temp_grant = 0;
        for (i = 0; i < num_masters; i = i + 1) begin
            if (req[(arb_counter + i) % num_masters]) begin
                temp_grant[(arb_counter + i) % num_masters] = 1;
                arb_counter <= (arb_counter + i + 1) % num_masters;
                break;
            end
        end
        grant <= temp_grant;
    end
end

endmodule
