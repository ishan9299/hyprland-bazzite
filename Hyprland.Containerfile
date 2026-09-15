ARG BUILDER_BASE_IMAGE=localhost/hyprland-base-packages:latest
FROM scratch as ctx

COPY build_files /
COPY system_files /system_files

FROM ${BUILDER_BASE_IMAGE} AS hyprland_builder

COPY --from=ctx /hyprland_source /hyprland_source

RUN mkdir -p /hyprland-out/usr

ENV PATH="/hyprland-out/usr/bin:${PATH}"

# ============================================================================
# hyprland-protocols
# ============================================================================

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
# EXPORT ARTIFACTS
# ============================================================================
FROM scratch
COPY --from=hyprland_builder /hyprland-out /
