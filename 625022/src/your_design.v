module data_transmission_channel (
    input clk,
    input rst,
    input [7:0] data_in,
    input inject_error,
    output reg [7:0] received_data,
    output reg error_detected
);

    reg [10:0] encoded_data;
    reg [10:0] received_data_encoded;
    reg p1, p2, p3;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_data <= 11'b0;
        end else begin
            p1 <= data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6];
            p2 <= data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6];
            p3 <= data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];
            encoded_data <= {p3, p2, p1, data_in};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            received_data_encoded <= 11'b0;
        end else begin
            if (inject_error) begin
                received_data_encoded <= encoded_data ^ (1 << 4);
            end else begin
                received_data_encoded <= encoded_data;
            end
        end
    end

    wire p1_received, p2_received, p3_received;
    wire [7:0] data_in_received;
    wire p1_check, p2_check, p3_check;
    wire [2:0] error_position;

    assign p1_received = received_data_encoded[10];
    assign p2_received = received_data_encoded[9];
    assign p3_received = received_data_encoded[8];
    assign data_in_received = received_data_encoded[7:0];

    assign p1_check = data_in_received[0] ^ data_in_received[1] ^ data_in_received[3] ^ data_in_received[4] ^ data_in_received[6] ^ p1_received;
    assign p2_check = data_in_received[0] ^ data_in_received[2] ^ data_in_received[3] ^ data_in_received[5] ^ data_in_received[6] ^ p2_received;
    assign p3_check = data_in_received[1] ^ data_in_received[2] ^ data_in_received[3] ^ data_in_received[7] ^ p3_received;

    assign error_position = p1_check + (p2_check << 1) + (p3_check << 2);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            error_detected <= 0;
            received_data <= 8'b0;
        end else begin
            if (error_position != 3'b000) begin
                error_detected <= 1;
                received_data <= data_in_received ^ (1 << (error_position - 1));
            end else begin
                error_detected <= 0;
                received_data <= data_in_received;
            end
        end
    end

endmodule
