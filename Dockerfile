# --- Stage 1: Build Stage (using Debian Trixie Slim for fast, reliable builds) ---
FROM rust:1.99-slim-trixie AS builder

# Declare the version of typos-cli to install
# renovate: datasource=crate depName=typos-cli
ARG TYPOS_VERSION=1.50.2

WORKDIR /usr/src/app

# Install build-essential (needed for GCC/linker if crates use C extensions)
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*

# Install the typos binary
RUN cargo install typos-cli --version ${TYPOS_VERSION} --locked

# --- Stage 2: Hardened Distroless Runtime Stage ---
FROM gcr.io/distroless/cc-debian12:nonroot

# Copy only the compiled binary from builder
COPY --from=builder /usr/local/cargo/bin/typos /usr/local/bin/typos

# Set non-root user context
USER nonroot:nonroot

ENTRYPOINT ["/usr/local/bin/typos"]
