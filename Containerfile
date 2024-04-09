FROM ghcr.io/vietchinh/fedora-minimal-init:39

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]
VOLUME [ "/var/run/libvirt/"]

RUN microdnf install qemu-kvm libvirt passt nano --setopt=install_weak_deps=False --nodocs -y && microdnf clean all && \
    systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable libvirtd-tcp.socket; systemctl enable container_init

CMD ["/sbin/init"]