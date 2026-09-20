FROM scratch as ctx
COPY build_files /

ARG FEDORA_VERSION
FROM quay.io/fedora/fedora:${FEDORA_VERSION} AS uwsm-builder

ARG UWSM_VERSION=0.27.0


RUN --mount=type=cache,dst=/var/cache/dnf \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install \
    meson ninja-build scdoc pkgconf \
    python3 python3-pyxdg python3-dbus \
    util-linux newt libnotify \
    inotify-tools curl tar && dnf clean all

RUN curl -fL -C - --retry 3 --retry-all-errors \
-o /tmp/uwsm-${UWSM_VERSION}.tar.gz \
"https://github.com/Vladimir-csp/uwsm/archive/refs/tags/v${UWSM_VERSION}.tar.gz"

RUN tar -xvf "/tmp/uwsm-${UWSM_VERSION}.tar.gz" -C /tmp

RUN meson setup \
    --prefix=/usr/local \
    -Duuctl=enabled \
    -Dfumon=enabled \
    -Duwsm-app=enabled \
    -Dttyautolock=enabled \
    "/tmp/uwsm-${UWSM_VERSION}/build" \
    "/tmp/uwsm-${UWSM_VERSION}"

RUN DESTDIR=/uwsm-out \
    meson install -C "/tmp/uwsm-${UWSM_VERSION}/build"
