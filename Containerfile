FROM docker.io/almalinux/9-init:latest
MAINTAINER vietchinh

RUN dnf install qemu-kvm libvirt -y && dnf clean all ; \
    systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable libvirtd-tcp.socket

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]

CMD ["/sbin/init"]