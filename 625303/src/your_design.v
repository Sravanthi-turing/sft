`timescale 1ns / 1ps

module MemoryArray #( 
    parameter MEM_TYPE = "REG",  
    parameter DATA_WIDTH = 8,    
    parameter ADDR_WIDTH = 4     
)(
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    localparam DEPTH = 1 << ADDR_WIDTH;
    
    generate
        if (MEM_TYPE == "REG") begin : REG_ARRAY
            reg [DATA_WIDTH-1:0] reg_mem [0:DEPTH-1];
            always @(posedge clk) begin
                if (we) reg_mem[addr] <= din;
                dout <= reg_mem[addr];
            end
        end 
        else if (MEM_TYPE == "LUT") begin : LUT_ARRAY
            reg [DATA_WIDTH-1:0] lut_mem [0:DEPTH-1];
            always @(posedge clk) begin
                if (we) lut_mem[addr] <= din;
                dout <= lut_mem[addr];
            end
        end 
        else if (MEM_TYPE == "BRAM") begin : BRAM_ARRAY
            reg [DATA_WIDTH-1:0] bram_mem [0:DEPTH-1];
            always @(posedge clk) begin
                if (we) bram_mem[addr] <= din;
                dout <= bram_mem[addr];
            end
        end
        else begin
            initial $fatal("Invalid MEM_TYPE parameter");
        end
    endgenerate
    
endmodule
