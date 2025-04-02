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
            integer i;
            initial begin
                for (i = 0; i < DEPTH; i = i + 1) 
                    reg_mem[i] = 0;
            end
            always @(posedge clk) begin
                if (we && addr < DEPTH) reg_mem[addr] <= din;
                if (addr < DEPTH) dout <= reg_mem[addr];
                else dout <= {DATA_WIDTH{1'bx}};
            end
        end 
        else if (MEM_TYPE == "LUT") begin : LUT_ARRAY
            reg [DATA_WIDTH-1:0] lut_mem [0:DEPTH-1];
            integer i;
            initial begin
                for (i = 0; i < DEPTH; i = i + 1) 
                    lut_mem[i] = 0;
            end
            always @(posedge clk) begin
                if (we && addr < DEPTH) lut_mem[addr] <= din;
                if (addr < DEPTH) dout <= lut_mem[addr];
                else dout <= {DATA_WIDTH{1'bx}};
            end
        end 
        else if (MEM_TYPE == "BRAM") begin : BRAM_ARRAY
            reg [DATA_WIDTH-1:0] bram_mem [0:DEPTH-1];
            integer i;
            initial begin
                for (i = 0; i < DEPTH; i = i + 1) 
                    bram_mem[i] = 0;
            end
            always @(posedge clk) begin
                if (we && addr < DEPTH) bram_mem[addr] <= din;
                if (addr < DEPTH) dout <= bram_mem[addr];
                else dout <= {DATA_WIDTH{1'bx}};
            end
        end
        else begin
            initial $fatal("Invalid MEM_TYPE parameter");
        end
    endgenerate
    
endmodule
