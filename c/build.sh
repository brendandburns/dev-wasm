#!/bin/bash
clang --target=wasm32-wasi --sysroot /tmp/wasi-libc -o main.wasm main.c --rtlib=compiler-rt
