# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install GTKWave and necessary dependencies
RUN apt-get update && apt-get install -y ^
    gtkwave ^
    x11-apps ^
    && rm -rf /var/lib/apt/lists/*

# Set the environment for X11 display forwarding
ENV DISPLAY=:0
