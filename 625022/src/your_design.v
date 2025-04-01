module Data_Channel #(parameter DATA_WIDTH = 8, ECC_WIDTH = 5) (
    input  wire clk,
    input  wire rst,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg  error_detected,
    output reg  error_corrected
);
    
    wire [DATA_WIDTH+ECC_WIDTH-1:0] encoded_data;
    reg  [DATA_WIDTH+ECC_WIDTH-1:0] received_data;
    reg  [ECC_WIDTH-1:0] ecc_received;
    reg  [ECC_WIDTH-1:0] syndrome;
    reg  [DATA_WIDTH-1:0] corrected_data;
    
    function [ECC_WIDTH-1:0] generate_ecc;
        input [DATA_WIDTH-1:0] d;
        begin
            generate_ecc[0] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6];
            generate_ecc[1] = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6];
            generate_ecc[2] = d[1] ^ d[2] ^ d[3] ^ d[7];
            generate_ecc[3] = d[4] ^ d[5] ^ d[6] ^ d[7];
            generate_ecc[4] = d[0] ^ d[1] ^ d[2] ^ d[3] ^ d[4] ^ d[5] ^ d[6] ^ d[7];
        end
    endfunction
    
    assign encoded_data = {generate_ecc(data_in), data_in};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            received_data <= 0;
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else begin
            received_data <= encoded_data; 
            ecc_received <= received_data[DATA_WIDTH+ECC_WIDTH-1:DATA_WIDTH];
            corrected_data = received_data[DATA_WIDTH-1:0]; 
            syndrome <= ecc_received ^ generate_ecc(corrected_data);
            error_detected <= |syndrome;
            error_corrected <= 0;
            
            case (syndrome)
                5'b00001: corrected_data[0] = ~corrected_data[0];
                5'b00010: corrected_data[1] = ~corrected_data[1];
                5'b00100: corrected_data[2] = ~corrected_data[2];
                5'b01000: corrected_data[3] = ~corrected_data[3];
                5'b10000: corrected_data[4] = ~corrected_data[4];
                default: error_corrected = 1;
            endcase
            
            data_out <= corrected_data;
        end
    end
    
endmodule
