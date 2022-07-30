# MIT License
#
# Copyright (c) 2022 ksco
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


FROM ubuntu:20.04 as build-stage

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt -y update && apt -y upgrade && \
    apt -y install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev \
           libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
           patchutils bc zlib1g-dev libexpat-dev git \
           pkg-config ninja-build \
           libglib2.0-dev libpixman-1-dev

# Build toolchain
WORKDIR /riscv/
RUN git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
WORKDIR /riscv/riscv-gnu-toolchain/
RUN ./configure --prefix=/opt/riscv
RUN make -j $(nproc) linux
RUN make -j $(nproc) build-qemu
RUN make install

FROM ubuntu:20.04 as production-stage

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && apt -y upgrade && \
    apt -y install build-essential git clang libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-stage /opt/riscv /opt/riscv
ENV PATH="/opt/riscv/bin:${PATH}"
ENV RISCV="/opt/riscv/"

# Test if requirements exists
RUN command -v riscv64-unknown-linux-gnu-gcc
CMD ["bash"]