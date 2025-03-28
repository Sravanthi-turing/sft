module mppt_controller (
    input wire clk, rst_n,              
    input wire [15:0] v_in, i_in,        
    output reg [7:0] pwm_out    
);

    reg signed [31:0] power, prev_power;  
    reg signed [15:0] prev_vin;           
    reg [7:0] duty_cycle;                 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_power <= 0;
            prev_vin   <= 0;
            duty_cycle <= 8'd128;  
            pwm_out    <= 8'd128;  // Initialize output
        end 
        else begin
            power <= v_in * i_in;  

            if (power > prev_power) begin
                if (v_in > prev_vin)
                    duty_cycle <= duty_cycle + 1;
                else
                    duty_cycle <= duty_cycle - 1;
            end 
            else begin
                if (v_in > prev_vin)
                    duty_cycle <= duty_cycle - 1;
                else
                    duty_cycle <= duty_cycle + 1;
            end

            prev_power <= power;
            prev_vin   <= v_in;
            pwm_out    <= duty_cycle; // Assign duty_cycle to output inside always block
        end
    end

endmodule
