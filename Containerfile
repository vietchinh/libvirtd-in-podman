FROM ghcr.io/vietchinh/fedora-minimal-init:39

COPY ["container_init.sh", "/usr/bin/"]
COPY ["container_init.service", "/etc/systemd/system/"]

VOLUME [ "/etc/libvirt"]
VOLUME [ "/var/lib/libvirt/"]
VOLUME [ "/var/run/libvirt/"]

RUN microdnf install qemu-kvm libvirt passt nano --setopt=install_weak_deps=False --nodocs -y && microdnf clean all && \
    systemctl enable libvirt-guests; systemctl mask libvirtd; systemctl enable container_init; \
    systemctl enable virtqemud.service; \
    systemctl enable virtinterfaced.service; \
    systemctl enable virtnetworkd.service; \
    systemctl enable virtnodedevd.service; \
    systemctl enable virtnwfilterd.service; \
    systemctl enable virtsecretd.service; \
    systemctl enable virtstoraged.service;

CMD ["/sbin/init"]