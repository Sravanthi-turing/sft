module high_speed_bus_ecc (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        valid,
    input  logic [31:0] data_in,
    output logic [38:0] data_out, 
    output logic        ecc_error
);
    
    logic [6:0] ecc;
    
    // ECC generation (Hamming code for 32-bit data)
    function logic [6:0] generate_ecc(input logic [31:0] d);
        logic [6:0] e;
        e[0] = ^d[31:0]; 
        e[1] = ^d[15:0];
        e[2] = ^d[7:0];
        e[3] = ^d[3:0];
        e[4] = ^d[1:0];
        e[5] = ^d[0];
        e[6] = ^{d[31:16], d[7:0]};
        return e;
    endfunction
    
    // ECC Error Detection logic
    function logic detect_ecc_error(input logic [31:0] d, input logic [6:0] received_ecc);
        logic [6:0] calculated_ecc;
        calculated_ecc = generate_ecc(d);
        return (calculated_ecc != received_ecc); 
    endfunction
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out  <= '0;
            ecc_error <= 1'b0;
        end else if (valid) begin
            ecc = generate_ecc(data_in);
            data_out = {data_in, ecc};
            ecc_error = detect_ecc_error(data_in, ecc);
        end
    end
endmodule
