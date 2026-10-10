# --- Stage 1: Build Stage ---
FROM rust:1.99-slim-trixie AS builder

# renovate: datasource=crate depName=typos-cli
ARG TYPOS_VERSION=1.51.1

# Install the typos binary directly
RUN cargo install typos-cli --version ${TYPOS_VERSION} --locked

# --- Stage 2: Hardened Distroless Runtime Stage ---
FROM gcr.io/distroless/cc-debian13:nonroot

# Copy only the compiled binary from builder
COPY --from=builder /usr/local/cargo/bin/typos /usr/local/bin/typos

# Set non-root user context
USER nonroot:nonroot

ENTRYPOINT ["/usr/local/bin/typos"]
