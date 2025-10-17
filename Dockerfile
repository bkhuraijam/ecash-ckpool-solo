FROM ubuntu:20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libcurl4-openssl-dev \
    libjansson-dev \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy source code into container
COPY . /opt/ckpool
WORKDIR /opt/ckpool

# Build the software
RUN mkdir -p m4 && \
    ./autogen.sh && \
    ./configure && \
    make

# Expose the default mining port
EXPOSE 3333

# Run the pool
CMD ["./ckpool", "-c", "ckpool.ecash.conf"]

