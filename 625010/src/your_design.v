module high_speed_bus_ecc (
    input  wire        clk,
    input  wire        reset_n,
    input  wire        valid,
    input  wire [31:0] data_in,
    output reg  [38:0] data_out, 
    output reg         ecc_error
);
    
    reg [6:0] ecc;
    
    function [6:0] generate_ecc;
        input [31:0] d;
        reg [6:0] e;
        begin
            e[0] = ^d[31:0]; 
            e[1] = ^d[15:0];
            e[2] = ^d[7:0];
            e[3] = ^d[3:0];
            e[4] = ^d[1:0];
            e[5] = ^d[0];
            e[6] = ^{d[31:16], d[7:0]};
            generate_ecc = e;
        end
    endfunction
    
    // ECC Error Detection
    function detect_ecc_error;
        input [31:0] d;
        input [6:0] received_ecc;
        reg [6:0] calculated_ecc;
        begin
            calculated_ecc = generate_ecc(d);
            detect_ecc_error = (calculated_ecc != received_ecc); 
        end
    endfunction
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out  <= 0;
            ecc_error <= 0;
        end else if (valid) begin
            ecc = generate_ecc(data_in);
            data_out = {data_in, ecc};
            ecc_error = detect_ecc_error(data_in, ecc);
        end
    end
endmodule
