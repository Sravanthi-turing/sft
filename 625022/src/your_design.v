module data_transmission_channel (
    input [7:0] data_in,
    input inject_error,
    output reg [7:0] received_data,
    output reg error_detected
);

    wire [10:0] encoded_data;
    wire p1, p2, p3;
    
    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6];
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6];
    assign p3 = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];
    
    assign encoded_data = {p3, p2, p1, data_in};
    
    reg [10:0] received_data_encoded;

    always @(*) begin
        if (inject_error) begin
            received_data_encoded = encoded_data ^ (1 << 4);
        end else begin
            received_data_encoded = encoded_data;
        end
    end

    wire p1_received = received_data_encoded[10];
    wire p2_received = received_data_encoded[9];
    wire p3_received = received_data_encoded[8];
    wire [7:0] data_in_received = received_data_encoded[7:0];

    wire p1_check, p2_check, p3_check;
    wire [2:0] error_position;

    assign p1_check = data_in_received[0] ^ data_in_received[1] ^ data_in_received[3] ^ data_in_received[4] ^ data_in_received[6] ^ p1_received;
    assign p2_check = data_in_received[0] ^ data_in_received[2] ^ data_in_received[3] ^ data_in_received[5] ^ data_in_received[6] ^ p2_received;
    assign p3_check = data_in_received[1] ^ data_in_received[2] ^ data_in_received[3] ^ data_in_received[7] ^ p3_received;

    assign error_position = p1_check + (p2_check << 1) + (p3_check << 2);

    always @(*) begin
        if (error_position != 3'b000) begin
            error_detected = 1;
            received_data = data_in_received ^ (1 << (error_position - 1));
        end else begin
            error_detected = 0;
            received_data = data_in_received;
        end
    end

endmodule
