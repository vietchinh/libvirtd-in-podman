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
RUN systemctl mask libvirtd; \
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

CMD ["/sbin/init"]