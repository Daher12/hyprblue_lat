# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/base-nvidia:latest

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

COPY --from=ghcr.io/ublue-os/akmods-nvidia:main-42 /rpms/ /tmp/rpms
      RUN find /tmp/rpms
      # RUN rpm-ostree install /tmp/rpms/ublue-os/ublue-os-nvidia*.rpm
      RUN sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' /etc/yum.repos.d/nvidia-container-toolkit.repo
      RUN sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-nvidia.repo   
      RUN rpm-ostree install libnvidia-fbc libva-nvidia-driver nvidia-driver nvidia-driver-cuda nvidia-modprobe nvidia-persistenced nvidia-settings nvidia-container-toolkit 
      #  RUN rpm-ostree install /tmp/rpms/kmods/kmod-nvidia*.rpm

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
