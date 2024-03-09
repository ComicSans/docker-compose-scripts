#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

echo "Creating docker macvlan..."
if docker network inspect docker-macvlan >/dev/null 2>&1; then
  docker network rm docker-macvlan
fi

docker network create -d macvlan \
  --opt parent=eth0 \
  --subnet 192.168.178.0/24 \
  --gateway 192.168.178.1 \
  --ip-range 192.168.178.192/27 \
  --aux-address 'host=192.168.178.223' \
  docker-macvlan

ip link add docker-shim link eth0 type macvlan mode bridge
ip addr add 192.168.178.223/32 dev docker-shim
ip link set docker-shim up
ip route add 192.168.178.192/27 dev docker-shim

echo "Making network shim interface persistent..."
cat <<EOF >/etc/network/if-up.d/99-docker-shim-network
#!/bin/sh
if [ "\$IFACE" = "wth0" ]; then
  if ip link show docker-shim >/dev/null 2>&1; then
    ip link del docker-shim
  fi
  ip link add docker-shim link eth0 type macvlan mode bridge
  ip addr add 192.168.178.223/32 dev docker-shim
  ip link set docker-shim up
  ip route add 192.168.178.192/27 dev docker-shim
fi
EOF
chmod a+rx /etc/network/if-up.d/99-docker-shim-network

