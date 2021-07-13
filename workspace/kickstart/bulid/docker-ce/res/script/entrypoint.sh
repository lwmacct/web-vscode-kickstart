#!/bin/bash
# 技术支持 QQ1713829947 http://lwm.icu
# 2020-12-13 04:05:55

__init_ages() {
	_rpm='/mnt/source/res/rpm'
	mkdir /root/install/
}

__install_rpm() {
	echo '开始安装Docker'
	rpm -ivh --force --nodeps $_rpm/docker-ce/*.rpm
}

__config_docker() {
	usermod -aG docker root
	mkdir -p /etc/docker
	cat >/etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://bn4ll166.mirror.aliyuncs.com"
    ],
    "data-root": "/data/docker-root",
    "dns": [
        "223.5.5.5",
        "119.29.29.29"
    ],
    "bip": "172.31.255.254/16",
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check=true"
    ],
    "userland-proxy": false,
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "50m",
        "max-file": "1"
    }
}
EOF
	systemctl enable docker

}



__init_ages
__install_rpm >/root/install/install_rpm.log
__config_docker
