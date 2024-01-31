FROM registry.fedoraproject.org/fedora:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]
VOLUME [ "/var/run/libvirt/"]

RUN useradd -U -s /sbin/nologin -c "Iwa Uzuka is a stand in user for polkit, connecting with outside user" iwauzuka

RUN dnf install systemd qemu-kvm libvirt passt nano --setopt=install_weak_deps=False --nodocs -y && dnf clean all

# https://libvirt.org/daemons.html#modular-driver-daemons
RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable libvirt-guests; systemctl mask libvirtd; systemctl enable container_init;
    systemctl unmask virtqemud.service;
    systemctl unmask virtinterfaced.service;
    systemctl unmask virtnetworkd.service;
    systemctl unmask virtnodedevd.service;
    systemctl unmask virtnwfilterd.service;
    systemctl unmask virtsecretd.service;
    systemctl unmask virtstoraged.service;
    systemctl unmask virtqemud{,-ro,-admin}.socket;
    systemctl unmask virtinterfaced{,-ro,-admin}.socket;
    systemctl unmask virtnetworkd{,-ro,-admin}.socket;
    systemctl unmask virtnodedevd{,-ro,-admin}.socket;
    systemctl unmask virtnwfilterd{,-ro,-admin}.socket;
    systemctl unmask virtsecretd{,-ro,-admin}.socket;
    systemctl unmask virtstoraged{,-ro,-admin}.socket;
    systemctl enable virtqemud.service;
    systemctl enable virtinterfaced.service;
    systemctl enable virtnetworkd.service;
    systemctl enable virtnodedevd.service;
    systemctl enable virtnwfilterd.service;
    systemctl enable virtsecretd.service;
    systemctl enable virtstoraged.service;
    systemctl enable virtqemud{,-ro,-admin}.socket;
    systemctl enable virtinterfaced{,-ro,-admin}.socket;
    systemctl enable virtnetworkd{,-ro,-admin}.socket;
    systemctl enable virtnodedevd{,-ro,-admin}.socket;
    systemctl enable virtnwfilterd{,-ro,-admin}.socket;
    systemctl enable virtsecretd{,-ro,-admin}.socket;
    systemctl enable virtstoraged{,-ro,-admin}.socket

CMD ["/sbin/init"]