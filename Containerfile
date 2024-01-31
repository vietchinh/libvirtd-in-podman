FROM registry.fedoraproject.org/fedora:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]
VOLUME [ "/var/run/libvirt/"]

RUN useradd -U -s /sbin/nologin -c "Iwa Uzuka is a stand in user for polkit, connecting with outside user" iwauzuka

RUN dnf install systemd qemu-kvm libvirt passt nano --setopt=install_weak_deps=False --nodocs -y && microdnf clean all

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable libvirt-guests; systemctl enable libvirtd; systemctl enable container_init

CMD ["/sbin/init"]