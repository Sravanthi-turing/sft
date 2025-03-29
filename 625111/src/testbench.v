module tb_crossbar_switch;
    reg clk, rst;
    reg [3:0] req;
    reg [1:0] dest[3:0];
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
        
        req = 4'b1001;
        dest[0] = 3; dest[3] = 0;
        data_in[0] = 32'hFFFFFFFF;
        data_in[3] = 32'h00000000;
        #10;
        
        req = 4'b0111;
        dest[0] = 1; dest[1] = 2; dest[2] = 3;
        data_in[0] = 32'h11111111;
        data_in[1] = 32'h22222222;
        data_in[2] = 32'h33333333;
        #10;
        
        $finish;
    end
    
    always @(posedge clk) begin
        integer i;
        for (i = 0; i < 4; i = i + 1) begin
            $display("Time: %0t | Req: %b | Dest[%0d]: %0d | Data In[%0d]: %h | Data Out[%0d]: %h | Grant[%0d]: %b", 
                $time, req[i], i, dest[i], i, data_in[i], i, data_out[i], i, grant[i]);
        end
    end
endmodule
