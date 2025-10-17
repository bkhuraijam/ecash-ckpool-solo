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
    # Install Autoconf 2.71 from source
RUN apt-get update && apt-get install -y wget build-essential && \
    wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz && \
    tar -xzf autoconf-2.71.tar.gz && \
    cd autoconf-2.71 && \
    ./configure && \
    make && \
    make install

# Copy source code into container
COPY . /opt/ckpool
WORKDIR /opt/ckpool

# Build the software
# Create m4 directory and initialize autotools
RUN mkdir -p m4 && \
    chmod +x autogen.sh && \
    ./autogen.sh && \
    ./configure && \
    make

# Expose the default mining port
EXPOSE 3333

# Run the pool
CMD ["./ckpool", "-c", "ckpool.ecash.conf"]

