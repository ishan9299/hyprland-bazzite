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
    libnotify-devel \
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

# Make binaries installed by earlier Hyprland components available to later
# components.
ENV PATH="/hyprland-out/usr/bin:${PATH}"

# Make pkg-config files installed by earlier components visible to later
# components.
ENV PKG_CONFIG_PATH="/hyprland-out/usr/lib64/pkgconfig:/hyprland-out/usr/lib/pkgconfig:/hyprland-out/usr/share/pkgconfig:${PKG_CONFIG_PATH}"


# ============================================================================
# hyprland-protocols
# ============================================================================

RUN pwd

RUN ls hyprland_source/hyprland-protocols

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprland-protocols \
    -B /tmp/hypr-build/hyprland-protocols

RUN cmake \
    --build /tmp/hypr-build/hyprland-protocols \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprland-protocols


# ============================================================================
# hyprwayland-scanner
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprwayland-scanner \
    -B /tmp/hypr-build/hyprwayland-scanner

RUN cmake \
    --build /tmp/hypr-build/hyprwayland-scanner \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprwayland-scanner


# ============================================================================
# hyprutils
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprutils \
    -B /tmp/hypr-build/hyprutils

RUN cmake \
    --build /tmp/hypr-build/hyprutils \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprutils


# ============================================================================
# hyprgraphics
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprgraphics \
    -B /tmp/hypr-build/hyprgraphics

RUN cmake \
    --build /tmp/hypr-build/hyprgraphics \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprgraphics


# ============================================================================
# hyprlang
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprlang \
    -B /tmp/hypr-build/hyprlang

RUN cmake \
    --build /tmp/hypr-build/hyprlang \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprlang


# ============================================================================
# hyprcursor
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprcursor \
    -B /tmp/hypr-build/hyprcursor

RUN cmake \
    --build /tmp/hypr-build/hyprcursor \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprcursor


# ============================================================================
# aquamarine
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/aquamarine \
    -B /tmp/hypr-build/aquamarine

RUN cmake \
    --build /tmp/hypr-build/aquamarine \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/aquamarine


# ============================================================================
# xdg-desktop-portal-hyprland
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/xdg-desktop-portal-hyprland \
    -B /tmp/hypr-build/xdg-desktop-portal-hyprland

RUN cmake \
    --build /tmp/hypr-build/xdg-desktop-portal-hyprland \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/xdg-desktop-portal-hyprland


# ============================================================================
# hyprwire
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprwire \
    -B /tmp/hypr-build/hyprwire

RUN cmake \
    --build /tmp/hypr-build/hyprwire \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprwire


# ============================================================================
# hyprtoolkit
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprtoolkit \
    -B /tmp/hypr-build/hyprtoolkit

RUN cmake \
    --build /tmp/hypr-build/hyprtoolkit \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprtoolkit


# ============================================================================
# hyprland
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprland \
    -B /tmp/hypr-build/hyprland

RUN cmake \
    --build /tmp/hypr-build/hyprland \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprland


# ============================================================================
# hyprpaper
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprpaper \
    -B /tmp/hypr-build/hyprpaper

RUN cmake \
    --build /tmp/hypr-build/hyprpaper \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprpaper


# ============================================================================
# hyprlock
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/hyprland-out/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprlock \
    -B /tmp/hypr-build/hyprlock

RUN cmake \
    --build /tmp/hypr-build/hyprlock \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprlock

# hyprlock installs its PAM configuration under /usr/etc on Fedora.
# Move it to /etc for the bootc final image.
RUN if [ -f /hyprland-out/usr/etc/pam.d/hyprlock ]; then \
        mkdir -p /hyprland-out/etc/pam.d && \
        mv /hyprland-out/usr/etc/pam.d/hyprlock \
           /hyprland-out/etc/pam.d/hyprlock && \
        rmdir --ignore-fail-on-non-empty \
            /hyprland-out/usr/etc/pam.d 2>/dev/null || true && \
        rmdir --ignore-fail-on-non-empty \
            /hyprland-out/usr/etc 2>/dev/null || true; \
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
