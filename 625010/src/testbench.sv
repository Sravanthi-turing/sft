module tb_high_speed_bus_ecc();
    logic clk;
    logic reset_n;
    logic valid;
    logic [31:0] data_in;
    logic [38:0] data_out;
    logic ecc_error;
    
    high_speed_bus_ecc uut (
        .clk(clk),
        .reset_n(reset_n),
        .valid(valid),
        .data_in(data_in),
        .data_out(data_out),
        .ecc_error(ecc_error)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("high_speed_bus_ecc.vcd");
        $dumpvars(0, tb_high_speed_bus_ecc);
        
        clk = 0;
        reset_n = 0;
        valid = 0;
        data_in = 0;
        
        #10 reset_n = 1;
        
        #10 valid = 1; data_in = 32'hA5A5A5A5;
        #10 valid = 1; data_in = 32'h5A5A5A5A;
        #10 valid = 1; data_in = 32'hFFFFFFFF;
        #10 valid = 1; data_in = 32'h00000000;
        #10 valid = 1; data_in = 32'h12345678;
        #10 valid = 1; data_in = 32'h87654321;
        #10 valid = 1; data_in = 32'hDEADBEEF;
        #10 valid = 1; data_in = 32'hCAFEBABE;
        #10 valid = 1; data_in = 32'h0F0F0F0F;
        #10 valid = 1; data_in = 32'hF0F0F0F0;
        
        #10 valid = 0;
        
        #50 $finish;
    end
endmodule
