## 文件说明
本文主题最终作用于目录 /config/workspace/kickstart/bulid/docker-ce/res/rpm
其目的是为了下载 RPM 包, 例如 下载 Docker 的所有依赖

运行一个CentOS 容器,使用容器下载Docker相关依赖




# 下载 file 文件夹内相关 yum.repos.d 


```bash

__yum_repos_d(){
    rm -rf /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d
    mkdir -p /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d/

    curl -o /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    curl -o /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d/CentOS-Base.repo
}
__yum_repos_d


```


### 进入宿主机命令行模式

```bash
nsenter --mount=/host/1/ns/mnt
```


### 运行一个 CentOS 容器用于下载rpm包
```bash
nsenter --mount=/host/1/ns/mnt
__run_centos() {
    docker rm -f centos
    docker run -itd --name=centos \
        --hostname=code \
        --restart=always \
        --privileged=true \
        --net=host \
        -v /proc:/host \
        -v /data/docker-data/vscode/workspace/kickstart/bulid/universal/res/rpm/:/rpm \
        centos:7.9.2009
}
__run_centos
docker exec -it centos bash
```
### 进入容器内部,安装 RPM 下载工具 yum-plugin-downloadonly
```bash
__set_mirrors() {
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
    
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo

    yum clean all
    yum makecache fast
    yum install -y yum-plugin-downloadonly -y
}
__set_mirrors
```

```bash
__download_all() {
    yum install --downloadonly --downloaddir=/rpm/all \
        abrt-addon-ccpp abrt-addon-python abrt-cli abrt-console-notification at attr bash-completion bind-utils blktrace bpftool bridge-utils bzip2 centos-indexhtml chrony crda crontabs cryptsetup cyrus-sasl-plain dmraid dosfstools ed ethtool file fprintd-pam hunspell hunspell-en kmod-kvdo kpatch ledmon libaio libreport-plugin-mailx libstoragemgmt logrotate lsof lvm2 man-db man-pages man-pages-overrides mdadm mlocate mtr nano net-tools ntpdate ntsysv pciutils pinfo plymouth pm-utils psacct quota rdate rfkill rng-tools rsync scl-utils setserial setuptool smartmontools sos sssd-client strace sysstat systemtap-runtime tcpdump tcsh teamd time traceroute unzip usb_modeswitch usbutils vdo vim-enhanced virt-what wget which words xfsdump yum-langpacks zip \
        e2fsprogs hdparm libaio-devel log4cplus log4cplus-devel lshw ntp parted psmisc xfsprogs-devel \
        lrzsz socat dstat glances jq tree bridge-utils \
        ipmitool open-vm-tools \
        yum-utils device-mapper-persistent-data lvm2 docker-ce

}
__download_all

__ss(){
    echo "aa" \
    "aaa" \
    "ddd" 
}
__ss