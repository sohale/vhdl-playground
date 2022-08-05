#!/bin/bash
# search "vhdl compile docker"
# Continuous integration for open FPGA projects - Benedek Rácz

# docker pull mariobarbareschi/vhdl_ci
# See https://hub.docker.com/r/mariobarbareschi/vhdl_ci
# Continuous Integration for the VHDL involving GHDL
# Contents of the working directory in that image is from: https://github.com/mariobarbareschi/vhdl_ci

docker run -it --rm \
   -v $(pwd):/xyz \
   mariobarbareschi/vhdl_ci \
   /bin/bash -c '
   : \
   && set -eux \
   && mkdir -p /xyz/build \
   && cd /xyz/build \
   && cmake .. \
   && make all test
   '
# --name dc0001
# --volumes-from dc0001
