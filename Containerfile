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

COPY --from=ghcr.io/ishan9299/hyprland-artifacts:latest@sha256:b9966b60c9476d4ee346f19ee7ae2d68a5506f6e59abd3a3e694c94ff362307a / /
COPY --from=ghcr.io/ishan9299/hyprland-ecosystem:latest@sha256:b379054376478af15ab4ce6fa357b1451c3af4c0978315956d25ca205e2cbc8d / /
COPY --from=ghcr.io/ishan9299/quickshell-artifacts:latest@sha256:0284597e2abcd820428283a79019dc47b47ca56adb60c0b42b8d189b93099e22 /quickshell-out /

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
