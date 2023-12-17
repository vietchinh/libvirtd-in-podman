#/bin/bash

# Script trace mode
if [ "${DEBUG_MODE}" == "true" ]; then
    set -o xtrace
fi

systemctl start libvirtd-tcp.socket