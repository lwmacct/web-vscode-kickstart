#!/usr/bin/env bash

__init_args() {
    _nic_list=$(ls /sys/class/net/ | grep -v "$(ls /sys/devices/virtual/net/)")
}

__for() {
    for _each in $_nic_list; do
        echo $_each "is appoint"
        __write_network_config $_each
    done

}

__write_network_config() {
    _nic_name=$1
    _nic=/etc/sysconfig/network-scripts/ifcfg-$_nic_name
    # _nic=/tmp/nic/ifcfg-$_nic_name

    echo 'TYPE=Ethernet' >$_nic
    echo 'PROXY_METHOD="none"' >>$_nic
    echo 'BROWSER_ONLY="no"' >>$_nic
    echo 'BOOTPROTO="dhcp" # 设置静态IP时把"dhcp"改成"static"' >>$_nic
    echo '#GATEWAY="" # 网关' >>$_nic
    echo '#IPADDR="" # IP' >>$_nic
    echo '#NETMASK="" # 子网掩码' >>$_nic
    echo 'DEFROUTE="yes"' >>$_nic
    echo 'DNS1="223.5.5.5"' >>$_nic
    echo 'DNS2="119.29.29.29"' >>$_nic
    echo 'IPV4_FAILURE_FATAL="no"' >>$_nic
    echo 'NAME='$_nic_name >>$_nic
    echo 'DEVICE='$_nic_name >>$_nic
    echo 'ONBOOT=yes' >>$_nic

}
mkdir -p /tmp/nic/
__init_args
__for
