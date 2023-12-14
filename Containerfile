FROM docker.io/almalinux/9-init:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

RUN dnf install qemu-kvm libvirt openssh-server -y && dnf clean all ; \
    systemctl enable libvirtd; systemctl enable virtlockd; systemctl enable libvirt-guests; systemctl enable sshd; systemctl enable container_init

VOLUME [ "/etc/libvirt" ]
VOLUME [ "/etc/ssh" ]

CMD ["/sbin/init"]