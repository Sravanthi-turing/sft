module Vehicular_Emissions_FSM (
    input logic clk, reset,  
    input logic [7:0] CO2_level,  
    output logic warning, critical  
);

    typedef enum logic [1:0] {IDLE, MONITOR} state_t;
    typedef enum logic [1:0] {NORMAL, WARN, CRITICAL} substate_t;

    state_t state, next_state;
    substate_t substate, next_substate;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            substate <= NORMAL;
        end else begin
            state <= next_state;
            substate <= next_substate;
        end
    end

    always_comb begin
        next_state = state;
        next_substate = substate;
        warning = 0;
        critical = 0;

        case (state)
            IDLE: begin
                if (CO2_level > 0) 
                    next_state = MONITOR;
            end

            MONITOR: begin
                if (CO2_level < 50) 
                    next_substate = NORMAL;
                else if (CO2_level < 100) begin
                    next_substate = WARN;
                    warning = 1;
                end else begin
                    next_substate = CRITICAL;
                    critical = 1;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
