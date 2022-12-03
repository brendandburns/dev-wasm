FROM ubuntu:22.04

# Rust
# rustc test.rs --target wasm32-wasi

# C
# clang --target=wasm32-wasi --sysroot /tmp/wasi-libc -o test.wasm test.c --rtlib=compiler-rt

# Dotnet
# dotnet new console -o MyFirstWasiApp
# cd MyFirstWasiApp
# dotnet add package Wasi.Sdk --prerelease
# dotnet build

# Go
# GOROOT=/usr/local/go tinygo build -wasm-abi=generic -target=wasi -o main.wasm main.go

RUN apt update && apt install curl xz-utils -y -qq
RUN curl https://wasmtime.dev/install.sh -sSf | bash

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN /root/.cargo/bin/rustup target add wasm32-wasi

# C (Clang)
RUN apt install llvm clang -y -qq
RUN apt install git make -y -qq
RUN git clone https://github.com/CraneStation/wasi-libc.git && cd wasi-libc && make install INSTALL_DIR=/tmp/wasi-libc
RUN curl https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/libclang_rt.builtins-wasm32-wasi-16.0.tar.gz -L --output libclang_rt.builtins-wasm32-wasi-16.0.tar.gz
RUN tar -xzf libclang_rt.builtins-wasm32-wasi-16.0.tar.gz
RUN mkdir /usr/lib/llvm-14/lib/clang/14.0.0/lib/wasi && mv lib/wasi/libclang_rt.builtins-wasm32.a /usr/lib/llvm-14/lib/clang/14.0.0/lib/wasi/

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
