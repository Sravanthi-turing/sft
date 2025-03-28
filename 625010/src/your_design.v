module high_speed_bus_interface (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic        valid_in,      // Input data valid
    input  logic [31:0] data_in,       // 32-bit input data
    output logic        valid_out,     // Output data valid
    output logic [31:0] data_out,      // Corrected data output
    output logic        error_detected,// Error detected flag
    output logic        error_corrected // Single-bit correction flag
);

    logic [6:0] ecc_parity;  // ECC parity bits
    logic [6:0] received_parity;

    // ECC Encoder - Generates parity bits
    ecc_encoder u_ecc_encoder (
        .data_in(data_in),
        .parity_out(ecc_parity)
    );

    // Latching Data & ECC for Transfer
    logic [31:0] latched_data;
    logic [6:0] latched_parity;
    logic valid_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            latched_data  <= 0;
            latched_parity <= 0;
            valid_reg <= 0;
        end else if (valid_in) begin
            latched_data  <= data_in;
            latched_parity <= ecc_parity;
            valid_reg <= 1;
        end else begin
            valid_reg <= 0;
        end
    end

    assign received_parity = latched_parity;

    // ECC Decoder - Detects and corrects errors
    ecc_decoder u_ecc_decoder (
        .data_in(latched_data),
        .parity_in(received_parity),
        .corrected_data(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    assign valid_out = valid_reg;

endmodule
module ecc_encoder (
    input  logic [31:0] data_in,
    output logic [6:0]  parity_out
);

    always_comb begin
        parity_out[0] = ^{data_in[0], data_in[1], data_in[3], data_in[4], data_in[6], 
                          data_in[8], data_in[10], data_in[11], data_in[13], data_in[15], 
                          data_in[17], data_in[19], data_in[21], data_in[23], data_in[25], 
                          data_in[26], data_in[28], data_in[30]};

        parity_out[1] = ^{data_in[0], data_in[2], data_in[3], data_in[5], data_in[6], 
                          data_in[9], data_in[10], data_in[12], data_in[13], data_in[16], 
                          data_in[18], data_in[20], data_in[22], data_in[24], data_in[25], 
                          data_in[27], data_in[28], data_in[31]};

        parity_out[2] = ^{data_in[1], data_in[2], data_in[3], data_in[7], data_in[8], 
                          data_in[9], data_in[10], data_in[14], data_in[15], data_in[16], 
                          data_in[17], data_in[21], data_in[22], data_in[23], data_in[24], 
                          data_in[29], data_in[30], data_in[31]};

        parity_out[3] = ^{data_in[4], data_in[5], data_in[6], data_in[7], data_in[8], 
                          data_in[9], data_in[10], data_in[20], data_in[21], data_in[22], 
                          data_in[23], data_in[24], data_in[25], data_in[26], data_in[27]};

        parity_out[4] = ^{data_in[11], data_in[12], data_in[13], data_in[14], data_in[15], 
                          data_in[16], data_in[17], data_in[18], data_in[19], data_in[20], 
                          data_in[21], data_in[22], data_in[23]};

        parity_out[5] = ^{data_in[27], data_in[28], data_in[29], data_in[30], data_in[31]};

        parity_out[6] = ^{parity_out[0], parity_out[1], parity_out[2], parity_out[3],
                          parity_out[4], parity_out[5], data_in};
    end
endmodule

module ecc_decoder (
    input  logic [31:0] data_in,
    input  logic [6:0]  parity_in,
    output logic [31:0] corrected_data,
    output logic        error_detected,
    output logic        error_corrected
);

    logic [6:0] syndrome;
    logic [31:0] data_corrected;
    logic error;

    // Compute Syndrome
    always_comb begin
        syndrome = parity_in ^ (^{data_in[0], data_in[1], data_in[3], data_in[4], data_in[6], 
                                 data_in[8], data_in[10], data_in[11], data_in[13], data_in[15], 
                                 data_in[17], data_in[19], data_in[21], data_in[23], data_in[25], 
                                 data_in[26], data_in[28], data_in[30]});

        error_detected = |syndrome;
        error_corrected = (syndrome != 7'b0000000);

        data_corrected = data_in;
        if (error_corrected) begin
            data_corrected[syndrome] = ~data_corrected[syndrome]; // Flip bit to correct error
        end
    end

    assign corrected_data = data_corrected;
endmodule
