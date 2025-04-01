module SensorInterface(
    input wire clk,
    input wire rst,
    input wire [15:0] sensor_data,
    input wire data_valid,
    output reg [15:0] processed_data,
    output reg decision
);

    typedef struct {
        logic [15:0] data;
        logic valid;
    } SensorPacket;
    
    SensorPacket sensor_fifo [0:7]; 
    integer head = 0;
    integer tail = 0;
    integer count = 0;
    
    typedef enum {IDLE, READ, PROCESS, DECIDE} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:    next_state = (data_valid) ? READ : IDLE;
            READ:    next_state = PROCESS;
            PROCESS: next_state = DECIDE;
            DECIDE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    always @(posedge clk) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            processed_data <= 0;
            decision <= 0;
        end else begin
            case (current_state)
                READ: begin
                    if (count < 8) begin
                        sensor_fifo[tail].data = sensor_data;
                        sensor_fifo[tail].valid = 1;
                        tail = (tail + 1) % 8;
                        count = count + 1;
                    end
                end
                PROCESS: begin
                    if (count > 0) begin
                        processed_data = sensor_fifo[head].data + 16'h10; 
                    end
                end
                DECIDE: begin
                    if (count > 0) begin
                        decision = (processed_data > 16'h80) ? 1 : 0; 
                        head = (head + 1) % 8;
                        count = count - 1;
                    end
                end
            endcase
        end
    end
endmodule
