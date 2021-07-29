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
    yum clean all
    yum makecache fast
    yum install -y yum-plugin-downloadonly -y
}
__set_mirrors
```

### 查看 Dcache 业务需要安装什么RPM 包
已知需要执行命令安装补充包 bash
```bash
yum groups install base
```
执行以上命令会提示你是否确认安装, 这个时候我们往上翻 注意到 Installing for group install "Base":
这行下面就是这个命令会安装的rpm包了,不需把 Installing for dependencies: 下面的软件包装上, 因为 yum-plugin-downloadonly 会自动帮我们解决依赖关系, 得到以下命令

```bash
__download_base() {
    yum install --downloadonly --downloaddir=/rpm/base abrt-addon-ccpp abrt-addon-python abrt-cli abrt-console-notification at attr bash-completion bind-utils blktrace bpftool bridge-utils bzip2 centos-indexhtml chrony crda crontabs cryptsetup cyrus-sasl-plain dmraid dosfstools ed ethtool file fprintd-pam hunspell hunspell-en kmod-kvdo kpatch ledmon libaio libreport-plugin-mailx libstoragemgmt logrotate lsof lvm2 man-db man-pages man-pages-overrides mdadm mlocate mtr nano net-tools ntpdate ntsysv pciutils pinfo plymouth pm-utils psacct quota rdate rfkill rng-tools rsync scl-utils setserial setuptool smartmontools sos sssd-client strace sysstat systemtap-runtime tcpdump tcsh teamd time traceroute unzip usb_modeswitch usbutils vdo vim-enhanced virt-what wget which words xfsdump yum-langpacks zip lrzsz socat
}
__download_base

```
执行以上命令成功下载 base 包,重新执行安装 base 包,因为还要处理Dcache另一行命令的依赖
```bash
yum groups install base -y
```

查看另一行命令的依赖
```bash
curl -Ss -o /tmp/CentOS7_init_passwd https://dcache.iqiyi.com/CentOS7_init_passwd
chmod +x /tmp/CentOS7_init_passwd && /tmp/CentOS7_init_passwd
```

```bash
__download_base() {
    yum install --downloadonly --downloaddir=/rpm/dcache dstat e2fsprogs glances hdparm libaio-devel log4cplus log4cplus-devel lshw ntp parted psmisc xfsprogs-devel
}
__download_base
```


### 下载 Dcoekr-ce RPM
```bash
__download_docker() {
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum makecache fast
    yum install --downloadonly --downloaddir=/rpm/docker-ce docker-ce
}
__download_docker

```

### 下载 硬件相关的RPM包
```bash
__download_device() {
    yum install --downloadonly --downloaddir=/rpm/device ipmitool  open-vm-tools
}
__download_device

```


sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

