# Build
FROM clux/muslrust:latest as cargo-build 

WORKDIR /usr/src/
RUN USER=root cargo new --bin amt
WORKDIR /usr/src/amt
COPY ./Cargo.toml ./Cargo.toml 
COPY ./Cargo.lock ./Cargo.lock 
RUN cargo build --release
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/amt* 
RUN rm src/*.rs 
COPY ./src ./src 
RUN cargo build --release

# Run
FROM alpine:latest 
WORKDIR /
# FROM scratch
# RUN apk --update add libressl-dev
COPY --from=cargo-build /usr/src/amt/target/x86_64-unknown-linux-musl/release/amt . 
CMD ["/amt"]
