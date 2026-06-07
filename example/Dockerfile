FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip wget \
    clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev libglu1-mesa

RUN git clone https://github.com/flutter/flutter.git \
    -b stable /flutter

ENV PATH="/flutter/bin:${PATH}"

RUN flutter config --enable-linux-desktop
RUN flutter precache --linux
RUN flutter doctor -v

WORKDIR /app

# Build from project root: docker build -f example/Dockerfile -t flutter-linux-builder .
COPY . /app

# Resolve dependencies inside the container so paths are correct
WORKDIR /app/example
RUN flutter pub get