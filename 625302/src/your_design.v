module Vehicular_Emissions_FSM (
    input clk, reset,  
    input [7:0] CO2_level,  
    output reg warning, critical  
);

    // Main FSM States
    parameter IDLE = 2'b00, MONITOR = 2'b01;
    reg [1:0] state, next_state;

    // Sub-FSM States (Emission Levels)
    parameter NORMAL = 2'b00, WARN = 2'b01, CRITICAL = 2'b10;
    reg [1:0] substate, next_substate;

    // Sequential Logic (State Transition)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            substate <= NORMAL;
        end else begin
            state <= next_state;
            substate <= next_substate;
        end
    end

    // Combinational Logic (Next State Logic)
    always @(*) begin
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
