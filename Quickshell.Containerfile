FROM scratch as ctx
COPY build_files /

ARG FEDORA_VERSION
FROM quay.io/fedora/fedora:${FEDORA_VERSION} AS quickshell-builder


RUN --mount=type=cache,dst=/var/cache/dnf \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install \
    clang lld cmake ninja-build git \
    qt6-qtbase-devel qt6-qtdeclarative-devel \
    libdrm-devel qt6-qtshadertools-devel spirv-tools-devel \
    pkgconf-pkg-config cli11-devel qt6-qtwayland-devel \
    wayland-devel wayland-protocols-devel mesa-libgbm-devel \
    vulkan-headers libxcb-devel pipewire-devel \
    polkit-devel glib2-devel pam-devel && dnf clean all

ENV CC=clang
ENV CXX=clang++

COPY --from=ctx /quickshell_source /quickshell_source

RUN cmake -GNinja \
      -S /quickshell_source/quickshell \
      -B /tmp/build -DCMAKE_BUILD_TYPE=Release

RUN DESTDIR=/quickshell-out ninja -C build install
