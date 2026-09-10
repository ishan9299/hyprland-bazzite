# ============================================================================
# Build context
# ============================================================================

FROM scratch AS ctx

COPY build_files /
COPY system_files /system_files



# ============================================================================
# Base Image
# ============================================================================

FROM ghcr.io/ublue-os/bazzite-dx:stable

COPY --from=ghcr.io/ishan9299/hyprland-artifacts:latest / /



# ============================================================================
# Image modifications
# ============================================================================

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh


# ============================================================================
# Linting
# ============================================================================

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/run \
    bootc container lint
