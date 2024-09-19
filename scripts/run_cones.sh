#!/bin/bash

# Create directories for storing logic cones and optimized files
mkdir -p ../logic_cones
mkdir -p ../optimized_cones

# Run Yosys to extract logic cones
yosys -s cone_extraction.ys

# Process each extracted logic cone using ABC and TLG conversion
for blif_file in ../logic_cones/logic_cone_*.blif; do
  output_name=$(basename "$blif_file" .blif)
  
  # Optimize the logic cone using ABC
  echo "Optimizing $blif_file with ABC..."
  abc -c "read_blif $blif_file; strash; collapse; write_blif ../optimized_cones/optimized_$output_name.blif"
  
  # Run the Python TLG conversion script for each optimized BLIF file
  echo "Running TLG conversion for optimized_$output_name..."
  python3 ../tlg_conversion.py "../optimized_cones/optimized_$output_name.blif"
done
