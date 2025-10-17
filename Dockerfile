FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and newer autoconf
RUN apt-get update && apt-get install -y \
    build-essential \
    yasm \
    autoconf \
    automake \
    libtool \
    pkgconf \
    libzmq3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone and build ecash-ckpool-solo
WORKDIR /opt
RUN git clone https://github.com/bkhuraijam/ecash-ckpool-solo.git
WORKDIR /opt/ecash-ckpool-solo

# Create missing m4 directory
RUN mkdir -p m4

# Build
RUN ./autogen.sh && ./configure && make

# Set working directory and default command
WORKDIR /opt/ecash-ckpool-solo/src
CMD ["./ckpool", "-x", "-c", "../ckpool.ecash.conf"]


