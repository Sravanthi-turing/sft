`timescale 1ns/1ps

module testbench;
    reg  [7:0] data_in;
    wire [3:0] parity_out;
    reg  [7:0] received_data;
    reg  [3:0] received_parity;
    wire [3:0] syndrome;
    wire error_detected;
    wire [7:0] corrected_data;

    // Instantiate Encoder
    ecc_encoder enc (
        .data_in(data_in),
        .parity_out(parity_out)
    );

    // Instantiate Decoder
    ecc_decoder dec (
        .data_in(received_data),
        .parity_in(received_parity),
        .syndrome(syndrome),
        .error_detected(error_detected),
        .corrected_data(corrected_data)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);

        // Test case 1: No errors
        data_in = 8'b10110011;
        #10;
        received_data = data_in;
        received_parity = parity_out;
        #10;
        $display("Data: %b, Syndrome: %b, Error: %b, Corrected Data: %b", 
                  received_data, syndrome, error_detected, corrected_data);

        // Test case 2: Introduce 1-bit error
        received_data = data_in ^ 8'b00000001; // Flip LSB
        #10;
        $display("Data with Error: %b, Syndrome: %b, Error: %b, Corrected Data: %b", 
                  received_data, syndrome, error_detected, corrected_data);

        // Test case 3: Introduce parity error
        received_parity = parity_out ^ 4'b0001; // Flip one parity bit
        #10;
        $display("Data: %b, Modified Parity: %b, Syndrome: %b, Error: %b, Corrected Data: %b", 
                  received_data, received_parity, syndrome, error_detected, corrected_data);

        #10;
        $finish;
    end
endmodule
