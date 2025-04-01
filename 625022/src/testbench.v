module tb_Data_Channel;
    reg clk;
    reg rst;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire error_detected;
    wire error_corrected;
    
    Data_Channel uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );
    
    initial begin
        $dumpfile("output/simulation_output.vcd");
        $dumpvars(0, tb_Data_Channel);
        clk = 0;
        rst = 1;
        data_in = 0;
        #10 rst = 0;
        
        data_in = 8'b10101010; #20;
        
        data_in = 8'b11001100; #20;
        
        data_in = 8'b11110000; #10;
        uut.received_data[0] = ~uut.received_data[0]; #20;
        
        data_in = 8'b00001111; #10;
        uut.received_data[1] = ~uut.received_data[1];
        uut.received_data[3] = ~uut.received_data[3]; #20;
        
        rst = 1; #10; rst = 0; #10;
        
        $finish;
    end
    
    always #5 clk = ~clk;
endmodule
