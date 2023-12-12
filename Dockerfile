FROM registry.fedoraproject.org/fedora:latest
MAINTAINER Vietchinh

RUN mkdir -p /root/.ssh && dnf install systemd -y && dnf install qemu-kvm libvirt openssh-server -y && dnf clean all ; \
    (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable libvirtd; systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable sshd

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]
RUN systemctl enable container_init

VOLUME [ "/etc/libvirt" ]

CMD ["/sbin/init"]
