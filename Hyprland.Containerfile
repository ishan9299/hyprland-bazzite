FROM scratch as ctx

COPY build_files /
COPY system_files /system_files

FROM quay.io/fedora/fedora:44 AS hyprland_builder

RUN --mount=type=cache,dst=/var/cache/dnf \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install \
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
      scdoc \
      meson \
      curl \
      python3 \
      \
      libqalculate-devel \
      && dnf clean all

COPY --from=ctx /hyprland_source /hyprland_source

RUN mkdir -p /hyprland-out/usr

ENV PATH="/hyprland-out/usr/bin:${PATH}"
ENV UWSM_TAG="0.26.7"

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprland-protocols


# ============================================================================
# hyprwayland-scanner
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprwayland-scanner


# ============================================================================
# hyprutils
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprutils


# ============================================================================
# hyprgraphics
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprgraphics


# ============================================================================
# hyprlang
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprlang


# ============================================================================
# hyprcursor
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprcursor


# ============================================================================
# aquamarine
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/aquamarine


# ============================================================================
# xdg-desktop-portal-hyprland
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/xdg-desktop-portal-hyprland


# ============================================================================
# hyprwire
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprwire


# ============================================================================
# hyprtoolkit
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprtoolkit


# ============================================================================
# hyprland
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprland


# ============================================================================
# hyprpaper
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
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

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprpaper


# ============================================================================
# hyprland-guiutils
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprland-guiutils \
    -B /tmp/hypr-build/hyprland-guiutils

RUN cmake \
    --build /tmp/hypr-build/hyprland-guiutils \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprland-guiutils

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprland-guiutils


# ============================================================================
# hyprlock
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/etc \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/etc \
    -S /hyprland_source/hyprlock \
    -B /tmp/hypr-build/hyprlock

RUN cmake \
    --build /tmp/hypr-build/hyprlock \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprlock

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprlock

# ============================================================================
# hyprlauncher
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/hyprland-out/usr \
    -S /hyprland_source/hyprlauncher \
    -B /tmp/hypr-build/hyprlauncher

RUN cmake \
    --build /tmp/hypr-build/hyprlauncher \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN cmake \
    --install /tmp/hypr-build/hyprlauncher

RUN DESTDIR=/hyprland-out cmake \
    --install /tmp/hypr-build/hyprlauncher

# ============================================================================
# uwsm
# ============================================================================

RUN mkdir -p /tmp/uwsm && \
    curl -L "https://github.com/Vladimir-csp/uwsm/archive/refs/tags/v${UWSM_TAG}.tar.gz" \
        -o "/tmp/uwsm/uwsm-v${UWSM_TAG}.tar.gz" && \
    tar -xzf "/tmp/uwsm/uwsm-v${UWSM_TAG}.tar.gz" -C /tmp/uwsm && \
    cd "/tmp/uwsm/uwsm-${UWSM_TAG}" && \
    meson setup \
        --prefix=/usr/local \
        -Duuctl=enabled \
        -Dfumon=enabled \
        -Duwsm-app=enabled \
        -Dttyautolock=enabled \
        build && \
    DESTDIR=/hyprland-out meson install -C build

# ============================================================================
# EXPORT ARTIFACTS
# ============================================================================
FROM scratch
COPY --from=hyprland_builder /hyprland-out /
