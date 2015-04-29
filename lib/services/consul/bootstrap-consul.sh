#!/bin/bash


# Inspired by Brandon Philips' consul bootstrap script
# https://gist.github.com/philips/56fa3f5dae9060fbd100

source /etc/environment

name=$(cat /etc/machine-id)
private_ip=${COREOS_PRIVATE_IPV4}

# TODO: set file in cloud config
# https://github.com/coreos/coreos-cloudinit/blob/master/Documentation/cloud-config.md
num_expected_nodes=$1

if [ ! -f /opt/consul ]; then
    mkdir /opt
    cd /opt
    mkdir /var/lib/consul
    wget -O /opt/consul.zip https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip
    unzip /opt/consul.zip
    rm /opt/consul.zip
    chmod +x /opt/consul
fi

etcdctl set /consul.io/bootstrap/machines/${name} ${COREOS_PRIVATE_IPV4}


do_join() {
    sleep 10
    docker exec consul /bin/consul join $@
}

docker pull progrium/consul

# Attempt to create bootstrap key
if etcdctl mk /consul.io/bootstrap/started true; then
    export EXPECT=$num_expected_nodes
    echo "expecting $EXPECT nodes to join bootstrap cluster"
    $(docker run --rm progrium/consul cmd:run ${COREOS_PRIVATE_IPV4})
else
    ips=$(etcdctl ls /consul.io/bootstrap/machines | while read line; do
      echo "$(etcdctl get ${line}) "
    done)

    ip=$(echo $ips | sed 's/\ .*//')
    echo "This cluster has already been bootstrapped"
    echo "Joining IPs: $ips"

    do_join "$ips" &
    $(docker run --rm progrium/consul cmd:run ${COREOS_PRIVATE_IPV4}::$ip)
fi
