FROM registry.fedoraproject.org/fedora-minimal:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

RUN microdnf install systemd qemu-kvm libvirt -y && microdnf clean all

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable libvirtd-tcp.socket; systemctl enable container_init


RUN echo "listen_tls = 0" >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_tcp = 1' >> /etc/libvirt/libvirtd.conf; \
    echo 'tls_port = "16514"' >> /etc/libvirt/libvirtd.conf; \
    echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf; \
    echo 'auth_tcp = "none"' >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_addr = "127.0.0.1"' >> /etc/libvirt/libvirtd.conf

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]

CMD ["/sbin/init"]