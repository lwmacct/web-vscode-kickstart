#!/bin/bash
# 设置静态IP

__init_args() {

    if [ $# -gt 3 ]; then
        _wk=$1
        _wg=$2
        _ip=$3
        _prefix=$4
    fi

    if [ $# -gt 4 ]; then
        _metric=$5
    fi

    _eth=/etc/sysconfig/network-scripts/ifcfg-${_wk}
}

__write_network_config() {

    echo 'TYPE="Ethernet"' >"$_eth"
    echo 'PROXY_METHOD="none"' >>"$_eth"
    echo 'BROWSER_ONLY="no"' >>"$_eth"
    echo 'BOOTPROTO="static"' >>"$_eth"
    echo 'DEFROUTE="yes"' >>"$_eth"
    echo 'IPV4_FAILURE_FATAL="no"' >>"$_eth"
    if [ "$_metric" ]; then echo 'IPV4_ROUTE_METRIC='"$_metric" >>"$_eth"; fi
    echo 'IPV6INIT="yes"' >>"$_eth"
    echo 'IPV6_AUTOCONF="yes"' >>"$_eth"
    echo 'IPV6_DEFROUTE="yes"' >>"$_eth"
    echo 'IPV6_FAILURE_FATAL="no"' >>"$_eth"
    echo 'IPV6_ADDR_GEN_MODE="stable-privacy"' >>"$_eth"
    echo 'NAME='"$_wk" >>"$_eth"
    echo 'DEVICE='"$_wk" >>"$_eth"
    echo 'ONBOOT="yes"' >>"$_eth"
    echo 'IPADDR='"$_ip" >>"$_eth"
    echo 'GATEWAY='"$_wg" >>"$_eth"
    echo 'PREFIX='"$_prefix" >>"$_eth"
    echo 'DNS1="223.5.5.5"' >>"$_eth"
    echo 'DNS2="119.29.29.29"' >>"$_eth"
    echo 'IPV6_PRIVACY="no"' >>"$_eth"
    sync
}

__restart_network() {
    /etc/init.d/network restart
}

__init_args "$@"
__write_network_config
__restart_network

echo -e '_wk\t'"$_wk"
echo -e '_wg\t'"$_wg"
echo -e '_ip\t'"$_ip"
echo -e '_eth\t'"$_eth"

ping -c2 -W1 baidu.com
