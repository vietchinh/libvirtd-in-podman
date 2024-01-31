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
    for drv in qemu interface network nodedev nwfilter secret storage; do systemctl unmask virt${drv}d.service systemctl unmask virt${drv}d{,-ro,-admin}.socket systemctl enable virt${drv}d.service systemctl enable virt${drv}d{,-ro,-admin}.socket; done

CMD ["/sbin/init"]