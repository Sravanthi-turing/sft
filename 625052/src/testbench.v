module tb_LowPowerArithmetic;
    reg [7:0] a, b;
    reg [1:0] op;
    wire [15:0] result;
    
    LowPowerArithmetic #(8) dut (.a(a), .b(b), .op(op), .result(result));
    
    initial begin
        $dumpfile("output/simulation_output.vcd");
        $dumpvars(0, tb_LowPowerArithmetic);
        
        a = 8'h0A; b = 8'h05; op = 2'b00; #10;
        a = 8'h14; b = 8'h08; op = 2'b01; #10;
        a = 8'h03; b = 8'h02; op = 2'b10; #10;
        a = 8'hFF; b = 8'h01; op = 2'b00; #10;
        
        a = 8'h00; b = 8'h00; op = 2'b00; #10;
        a = 8'hFF; b = 8'hFF; op = 2'b01; #10;
        a = 8'h7F; b = 8'h01; op = 2'b00; #10;
        a = 8'h80; b = 8'h80; op = 2'b10; #10;
        a = 8'h01; b = 8'hFF; op = 2'b01; #10;
        a = 8'hFF; b = 8'h02; op = 2'b10; #10;
        a = 8'h00; b = 8'hFF; op = 2'b10; #10;
        a = 8'h55; b = 8'hAA; op = 2'b10; #10;
        a = 8'hFF; b = 8'hFF; op = 2'b10; #10;
        a = 8'h01; b = 8'h01; op = 2'b11; #10;
        
        $finish;
    end
endmodule
