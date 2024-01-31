FROM registry.fedoraproject.org/fedora:latest
MAINTAINER vietchinh

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]
VOLUME [ "/var/run/libvirt/"]

RUN useradd --user-group --create-home --shell /bin/bash --comment "Iwa Uzuka is a stand in user for polkit, connecting with outside user" iwauzuka

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
    systemctl mask libvirtd; \
    systemctl enable libvirt-guests; \
    systemctl enable container_init; \
    systemctl enable virtqemud.service; \
    systemctl enable virtinterfaced.service; \
    systemctl enable virtnetworkd.service; \
    systemctl enable virtnodedevd.service; \
    systemctl enable virtnwfilterd.service; \
    systemctl enable virtsecretd.service; \
    systemctl enable virtstoraged.service; \
    systemctl enable virtproxyd.service

COPY 50-libvirt-passwordless.rules /etc/polkit-1/rules.d/

CMD ["/sbin/init"]