FROM ubuntu:22.04

# wasmtime
RUN apt update && \
    apt install curl xz-utils -y -qq && \
    curl https://wasmtime.dev/install.sh -sSf | bash

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    /root/.cargo/bin/rustup target add wasm32-wasi

# C (Clang)
ENV WASI_VERSION=17
ENV WASI_VERSION_FULL=17.0
RUN apt install llvm clang -y -qq
RUN curl https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz -L --output wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz && \
    tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz && \
    rm wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz

# Dotnet
RUN apt install lld-14 -y -qq
RUN curl https://packages.microsoft.com/config/ubuntu/22.10/packages-microsoft-prod.deb -L --output packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y dotnet-sdk-7.0

# Golang
RUN curl https://github.com/tinygo-org/tinygo/releases/download/v0.26.0/tinygo_0.26.0_amd64.deb -L --output tinygo_0.26.0_amd64.deb && \
    dpkg -i tinygo_0.26.0_amd64.deb && \
    rm tinygo_0.26.0_amd64.deb && \
    curl --output go1.19.3.linux-amd64.tar.gz https://go.dev/dl/go1.19.3.linux-amd64.tar.gz -L && \
    tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz && \
    rm go1.19.3.linux-amd64.tar.gz

# ActionScript
RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt install -y -qq nodejs

COPY assemblyscript /root/assemblyscript
COPY c /root/c
COPY dotnet /root/dotnet
COPY rust /root/rust
COPY go /root/go
