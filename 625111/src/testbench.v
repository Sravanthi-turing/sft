
module tb_crossbar_switch;
    reg clk, rst;
    reg [3:0] req;
    reg [3:0] dest[3:0];
    reg [31:0] data_in[3:0];
    wire [31:0] data_out[3:0];
    wire [3:0] grant;
    
    crossbar_switch #(.N(4), .M(4)) uut (
        .clk(clk),
        .rst(rst),
        .req(req),
        .dest(dest),
        .data_in(data_in),
        .data_out(data_out),
        .grant(grant)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("/output/simulation_out.vcd");
        $dumpvars(0, tb_crossbar_switch);
        clk = 0; rst = 1;
        req = 4'b0000;
        dest[0] = 0; dest[1] = 1; dest[2] = 2; dest[3] = 3;
        data_in[0] = 32'hA1A1A1A1;
        data_in[1] = 32'hB2B2B2B2;
        data_in[2] = 32'hC3C3C3C3;
        data_in[3] = 32'hD4D4D4D4;
        
        #10 rst = 0;
        
        req = 4'b1111;
        #10;
        
        dest[1] = 3;
        #10;
        
        dest[0] = 2; dest[2] = 2;
        #10;
        
        rst = 1;
        #10 rst = 0;
        req = 4'b1010;
        dest[1] = 1; dest[3] = 2;
        #10;
        
        req = 4'b1100;
        dest[0] = 1; dest[2] = 3;
        data_in[0] = 32'hDEADBEEF;
        data_in[2] = 32'hCAFEBABE;
        #10;
        
        req = 4'b0110;
        dest[1] = 0; dest[2] = 1;
        data_in[1] = 32'h12345678;
        data_in[2] = 32'h87654321;
        #10;
        
        rst = 1;
        #10 rst = 0;
        req = 4'b0001;
        dest[3] = 2;
        data_in[3] = 32'hABCDEF01;
        #10;
        
        $finish;
    end
endmodule
