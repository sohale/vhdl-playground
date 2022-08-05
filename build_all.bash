#!/bin/bash
# search "vhdl compile docker"
# Continuous integration for open FPGA projects - Benedek Rácz

# docker pull mariobarbareschi/vhdl_ci
# See https://hub.docker.com/r/mariobarbareschi/vhdl_ci
# Continuous Integration for the VHDL involving GHDL

docker run -it --rm \
   -v $(pwd):/opt/build \
   mariobarbareschi/vhdl_ci \
   /bin/bash -c '
   mkdir -p /opt/build \
   && cd /opt/build \
   && cmake .. \
   && make all test
   '
# --name dc0001
# --volumes-from dc0001
