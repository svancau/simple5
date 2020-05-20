#!/usr/bin/env python3
from vunit import VUnit
import subprocess
import glob

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

vu.add_compile_option('ghdl.a_flags', ['--std=08'])

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("*.vhd")
lib.add_source_files("../rtl/*.vhd")

# Run vunit function
vu.main()
