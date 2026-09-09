# ============================================================================
# Build context
# ============================================================================

FROM scratch AS ctx

COPY build_files /
COPY system_files /system_files


# ============================================================================
# Hyprland builder
# ============================================================================

FROM quay.io/fedora/fedora@sha256:083414712cefa4ea7c219bb850b8d8027d0c7b8978bc743780269ebbdb700eb7 AS hyprland-builder

RUN --mount=type=cache,dst=/var/cache/dnf \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install \
    \
    cmake \
    ninja-build \
    gcc-c++ \
    git \
    curl \
    \
    pugixml-devel \
    \
    pixman-devel \
    cairo-devel \
    libjpeg-turbo-devel \
    libwebp-devel \
    libjxl-devel \
    file-devel \
    libpng-devel \
    librsvg2-devel \
    mesa-libGL-devel \
    libglvnd-devel \
    \
    libzip-devel \
    tomlplusplus-devel \
    \
    libseat-devel \
    libinput-devel \
    wayland-devel \
    wayland-protocols-devel \
    mesa-libgbm-devel \
    systemd-devel \
    libdisplay-info-devel \
    hwdata-devel \
    \
    libdrm-devel \
    pipewire-devel \
    sdbus-cpp-devel \
    qt6-qtbase-devel \
    qt6-qtwayland-devel \
    libuuid-devel \
    \
    iniparser-devel \
    abseil-cpp-devel \
    \
    glslang-devel \
    libXcursor-devel \
    libei-devel \
    re2-devel \
    muParser-devel \
    libcanberra-devel \
    libeis-devel \
    xcb-util-wm-devel \
    xcb-util-errors-devel \
    readline-devel \
    lua-devel \
    \
    pam-devel \
    \
    dunst \
    \
    && dnf clean all


# Source must be writable because some Hyprland projects generate files
# inside their source tree during the build.
COPY --from=ctx /hyprland_source /hyprland_source


RUN mkdir -p /hyprland-out/usr
ENV PATH="/hyprland-out/usr/bin:${PATH}"


# Generic component builder
RUN cat > /usr/local/bin/build-hypr <<'EOF'
#!/bin/bash
set -euo pipefail

name="$1"

SOURCE_ROOT=/hyprland_source
BUILD_ROOT=/tmp/hypr-build
OUT=/hyprland-out

source_dir="$SOURCE_ROOT/$name"
build_dir="$BUILD_ROOT/$name"

echo
echo "========================================"
echo "Building $name"
echo "========================================"

if [[ ! -d "$source_dir" ]]; then
    echo "ERROR: source directory does not exist:"
    echo "  $source_dir"
    exit 1
fi

mkdir -p "$BUILD_ROOT"

cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH="$OUT/usr" \
    -DCMAKE_PREFIX_PATH:PATH="$OUT/usr" \
    -S "$source_dir" \
    -B "$build_dir"

cmake \
    --build "$build_dir" \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

cmake --install "$build_dir"
EOF

RUN chmod +x /usr/local/bin/build-hypr


# ============================================================================
# Hyprland components
# ============================================================================

RUN build-hypr hyprland-protocols

RUN build-hypr hyprwayland-scanner

RUN build-hypr hyprutils

RUN build-hypr hyprgraphics

RUN build-hypr hyprlang

RUN build-hypr hyprcursor

RUN build-hypr aquamarine

RUN build-hypr xdg-desktop-portal-hyprland

RUN build-hypr hyprwire

RUN build-hypr hyprtoolkit

RUN build-hypr hyprland

RUN build-hypr hyprpaper

RUN build-hypr hyprlock && \
      if [ -f /hyprland-out/usr/etc/pam.d/hyprlock ]; then \
        mkdir -p /hyprland-out/etc/pam.d && \
        mv /hyprland-out/usr/etc/pam.d/hyprlock \
        /hyprland-out/etc/pam.d/hyprlock && \
        rmdir --ignore-fail-on-non-empty /hyprland-out/usr/etc/pam.d 2>/dev/null || true && \
        rmdir --ignore-fail-on-non-empty /hyprland-out/usr/etc 2>/dev/null || true; \
      fi

# ============================================================================
# Base Image
# ============================================================================

FROM ghcr.io/ublue-os/bazzite:stable@sha256:9556db65991d57a03a7dc18e4ba28a686d8bcdcd6b61235aa69c8267bb22ff76


# ============================================================================
# Hyprland
# ============================================================================

COPY --from=hyprland-builder /hyprland-out/ /


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
