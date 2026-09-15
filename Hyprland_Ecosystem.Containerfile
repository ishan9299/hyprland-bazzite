# ============================================================================
# Build context
# ============================================================================

ARG HYPRLAND_IMAGE=ghcr.io/ishan9299/hyprland-artifacts:latest
ARG BUILDER_BASE_IMAGE=ghcr.io/ishan9299/hyprland-base-packages:latest
FROM scratch AS ctx

COPY build_files /
COPY system_files /system_files


# ============================================================================
# Hyprland artifacts
#
# This image is produced by Hyprland.Containerfile.
# It contains the already-built Hyprland core and libraries.
# ============================================================================


FROM ${HYPRLAND_IMAGE} AS hyprland



# ============================================================================
# Ecosystem builder
# ============================================================================

FROM ${BUILDER_BASE_IMAGE} AS hyprland_ecosystem_builder

# ============================================================================
# Bring already-built Hyprland artifacts into the build environment
# ============================================================================

COPY --from=hyprland / /


# ============================================================================
# Ecosystem source
# ============================================================================

COPY --from=ctx /hyprland_ecosystem_source /hyprland_ecosystem_source


# ============================================================================
# Ecosystem artifact output
# ============================================================================

RUN mkdir -p /hyprland-ecosystem-out/usr

ENV PATH="/hyprland-ecosystem-out/usr/bin:${PATH}"

ENV CC=gcc
ENV CXX=g++

# Allow CMake/pkg-config to find the artifacts produced by Hyprland.
ENV CMAKE_PREFIX_PATH="/usr:/hyprland-ecosystem-out/usr"
ENV PKG_CONFIG_PATH="/usr/lib64/pkgconfig:/usr/share/pkgconfig:/hyprland-ecosystem-out/usr/lib64/pkgconfig:/hyprland-ecosystem-out/usr/share/pkgconfig"

# ============================================================================
# hyprlauncher
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprlauncher \
    -B /tmp/hypr-build/hyprlauncher

RUN cmake \
    --build /tmp/hypr-build/hyprlauncher \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprlauncher


# ============================================================================
# hyprpaper
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprpaper \
    -B /tmp/hypr-build/hyprpaper

RUN cmake \
    --build /tmp/hypr-build/hyprpaper \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprpaper


# ============================================================================
# hyprpicker
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprpicker \
    -B /tmp/hypr-build/hyprpicker

RUN cmake \
    --build /tmp/hypr-build/hyprpicker \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprpicker

# ============================================================================
# hypridle
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hypridle \
    -B /tmp/hypr-build/hypridle

RUN cmake \
    --build /tmp/hypr-build/hypridle \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hypridle

# ============================================================================
# hyprlock
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprlock \
    -B /tmp/hypr-build/hyprlock

RUN cmake \
    --build /tmp/hypr-build/hyprlock \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprlock

# ============================================================================
# hyprsysteminfo
# ============================================================================

# RUN cmake \
#     --no-warn-unused-cli \
#     -DCMAKE_BUILD_TYPE:STRING=Release \
#     -DCMAKE_INSTALL_PREFIX:PATH=/usr \
#     -DCMAKE_PREFIX_PATH:PATH=/usr \
#     -S /hyprland_ecosystem_source/hyprsysteminfo \
#     -B /tmp/hypr-build/hyprsysteminfo
#
# RUN cmake \
#     --build /tmp/hypr-build/hyprsysteminfo \
#     --config Release \
#     --target all \
#     -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
#
# RUN DESTDIR=/hyprland-ecosystem-out cmake \
#     --install /tmp/hypr-build/hyprsysteminfo

# ============================================================================
# hyprsunset
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprsunset \
    -B /tmp/hypr-build/hyprsunset

RUN cmake \
    --build /tmp/hypr-build/hyprsunset \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprsunset

# ============================================================================
# hyprland-qt-support
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprland-qt-support \
    -B /tmp/hypr-build/hyprland-qt-support

RUN cmake \
    --build /tmp/hypr-build/hyprland-qt-support \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprland-qt-support

# ============================================================================
# hyprqt6engine
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprqt6engine \
    -B /tmp/hypr-build/hyprqt6engine

RUN cmake \
    --build /tmp/hypr-build/hyprqt6engine \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprqt6engine

# ============================================================================
# hyprpwcenter
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprpwcenter \
    -B /tmp/hypr-build/hyprpwcenter

RUN cmake \
    --build /tmp/hypr-build/hyprpwcenter \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprpwcenter

# ============================================================================
# hyprshutdown
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprshutdown \
    -B /tmp/hypr-build/hyprshutdown

RUN cmake \
    --build /tmp/hypr-build/hyprshutdown \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprshutdown

# ============================================================================
# hyprguiutils
# ============================================================================

RUN cmake \
    --no-warn-unused-cli \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DCMAKE_PREFIX_PATH:PATH=/usr \
    -S /hyprland_ecosystem_source/hyprland-guiutils \
    -B /tmp/hypr-build/hyprland-guiutils

RUN cmake \
    --build /tmp/hypr-build/hyprland-guiutils \
    --config Release \
    --target all \
    -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

RUN DESTDIR=/hyprland-ecosystem-out cmake \
    --install /tmp/hypr-build/hyprland-guiutils

# ============================================================================
# EXPORT ECOSYSTEM ARTIFACTS
# ============================================================================

FROM scratch

COPY --from=hyprland_ecosystem_builder /hyprland-ecosystem-out /
