FROM docker.io/almalinux/9-init:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

RUN dnf install qemu-kvm libvirt -y && dnf clean all ; \
    systemctl enable libvirtd; systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable libvirtd-tcp.socket; systemctl enable container_init

RUN sed -i "s/^#\?listen_tls = 0\+$/listen_tls = 0/" /etc/libvirt/libvirtd.conf; \
    sed -i "s/^#\?#isten_tcp = 1$/listen_tcp = 1/" /etc/libvirt/libvirtd.conf; \
    sed -i "s/^#\?#tls_port = \"16514\"$/tls_port = \"16514\"/" /etc/libvirt/libvirtd.conf; \
    sed -i "s/^#\?#tcp_port = \"16509\"$/tcp_port = \"16509\"/" /etc/libvirt/libvirtd.conf; \
    sed -i "s/^#\?#listen_addr = \"127.0.0.1\"$/tls_port = \"127.0.0.1\"/" /etc/libvirt/libvirtd.conf; \

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]

CMD ["/sbin/init"]