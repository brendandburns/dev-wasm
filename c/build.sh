#!/bin/bash
WASI_SDK=/wasi-sdk-17.0
${WASI_SDK}/bin/clang --target=wasm32-wasi --sysroot=${WASI_SDK}/share/wasi-sysroot -o main.wasm main.c

${WASI_SDK}/bin/clang++ --target=wasm32-wasi --sysroot=${WASI_SDK}/share/wasi-sysroot -o main-cc.wasm main.cc
