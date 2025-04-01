

module tb_data_transmission_system;

    reg [7:0] data_in;
    reg inject_error;
    wire [7:0] received_data;
    wire error_detected;

    data_transmission_system uut (
        .data_in(data_in),
        .inject_error(inject_error),
        .received_data(received_data),
        .error_detected(error_detected)
    );

    initial begin
        $dumpfile("ecc_waveform.vcd");
        $dumpvars(0, tb_data_transmission_system);

        data_in = 8'b10101010;
        inject_error = 0;
        #10;

        data_in = 8'b11001100;
        inject_error = 1;
        #10;

        data_in = 8'b11110000;
        inject_error = 0;
        #10;

        data_in = 8'b00000001;
        inject_error = 0;
        #10;

        data_in = 8'b01010101;
        inject_error = 1;
        #10;

        data_in = 8'b10010010;
        inject_error = 0;
        #10;

        data_in = 8'b11100000;
        inject_error = 1;
        #10;

        data_in = 8'b00101010;
        inject_error = 0;
        #10;

        data_in = 8'b11111111;
        inject_error = 1;
        #10;

        data_in = 8'b00011100;
        inject_error = 0;
        #10;

        $finish;
    end

endmodule
