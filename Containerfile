FROM registry.fedoraproject.org/fedora-minimal:latest
MAINTAINER vietchinh

RUN microdnf install qemu-kvm libvirt -y && microdnf clean all; \
    systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable libvirtd-tcp.socket

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]

CMD ["/sbin/init"]