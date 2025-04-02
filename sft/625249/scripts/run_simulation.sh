#!/bin/bash

# Define file paths
VERILOG_DIR="/src"
OUTPUT_DIR="/output"
DESIGN_FILE="$VERILOG_DIR/your_design.v"
TESTBENCH_FILE="$VERILOG_DIR/testbench.v"
VCD_OUTPUT_FILE="$OUTPUT_DIR/simulation_output.vcd"

# Create output directory if not present
mkdir -p ./output

# Run Docker command to simulate the Verilog code
docker run --rm \
    -v "$(pwd)/src":/src \
    -v "$(pwd)/output":/output \
    hdlc/sim /bin/bash -c "
    iverilog -o /output/simulation.out /src/testbench.v /src/your_design.v &&
    vvp /output/simulation.out +vcd=/output/simulation_output.vcd
"

# Check if VCD file was created successfully
if [ -f ./output/simulation_output.vcd ]; then
    echo "Simulation complete. Output saved to ./output/simulation_output.vcd"
else
    echo "Simulation failed. Check your Verilog code for errors."
fi