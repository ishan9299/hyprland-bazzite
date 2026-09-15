ARG FEDORA_VERSION
FROM quay.io/fedora/fedora:${FEDORA_VERSION}:stable

RUN --mount=type=cache,dst=/var/cache/dnf \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install \
    gcc gcc-c++ clang lld cmake ninja-build git curl \
    pugixml-devel \
    pixman-devel cairo-devel libjpeg-turbo-devel libwebp-devel \
    libjxl-devel file-devel libpng-devel librsvg2-devel \
    mesa-libGL-devel libglvnd-devel \
    libzip-devel tomlplusplus-devel \
    libseat-devel libinput-devel wayland-devel wayland-protocols-devel \
    mesa-libgbm-devel systemd-devel libdisplay-info-devel \
    hwdata-devel \
    libdrm-devel pipewire-devel sdbus-cpp-devel \
    qt6-qtbase-devel qt6-qtwayland-devel libuuid-devel \
    iniparser-devel abseil-cpp-devel glslang-devel \
    libXcursor-devel libei-devel re2-devel muParser-devel \
    libcanberra-devel libeis-devel xcb-util-wm-devel \
    xcb-util-errors-devel readline-devel lua-devel \
    libnotify-devel libqalculate-devel pam-devel \
    pciutils-devel qt6-qtbase-devel qt6-qtbase-private-devel \
    qt6-qtwayland-devel \
    && dnf clean all
