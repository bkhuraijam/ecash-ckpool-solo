FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies including full ZMQ support
RUN apt-get update && apt-get install -y \
    build-essential \
    yasm \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libzmq3-dev \
    libczmq-dev \
    libcurl4-openssl-dev \
    libjansson-dev \
    libssl-dev \
    libgmp-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone and build ecash-ckpool-solo
WORKDIR /opt
RUN git clone https://github.com/bkhuraijam/ecash-ckpool-solo.git
WORKDIR /opt/ecash-ckpool-solo

# Create missing m4 directory
RUN mkdir -p m4

# Build CKPool with ZMQ support
RUN ./autogen.sh && ./configure --with-zmq && make

# Set working directory and default command
WORKDIR /opt/ecash-ckpool-solo/src
CMD ["./ckpool", "-x", "-c", "/config/ckpool.ecash.conf"]
