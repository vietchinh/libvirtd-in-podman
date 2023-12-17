FROM registry.fedoraproject.org/fedora-minimal:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

RUN microdnf install systemd qemu-kvm libvirt -y && microdnf clean all; \
    systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable libvirtd-tcp.socket

RUN echo "listen_tls = 0" >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_tcp = 1' >> /etc/libvirt/libvirtd.conf; \
    echo 'tls_port = "16514"' >> /etc/libvirt/libvirtd.conf; \
    echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf; \
    echo 'auth_tcp = "none"' >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_addr = "127.0.0.1"' >> /etc/libvirt/libvirtd.conf; \
    echo 'LIBVIRTD_ARGS="--listen"' >> /etc/sysconfig/libvirtd

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]

CMD ["/sbin/init"]