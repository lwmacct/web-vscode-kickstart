#!/usr/bin/env bash

__prepare() {
    # 复制文件到 iso 文件目录 为打包镜像做准备
    rm -rf /config/workspace/kickstart/mkisofs/res
    cp -rf /config/workspace/kickstart/bulid/universal/res /config/workspace/kickstart/mkisofs/
    cat /config/workspace/kickstart/bulid/universal/isolinux.cfg >/config/workspace/kickstart/mkisofs/isolinux/isolinux.cfg
}
__prepare

__mkisofs() {
    # 开始 打包iso
    mkdir -p /config/workspace/kickstart/bulid/universal/finish/
    mkisofs -R -J -T -r -l -d -joliet-long -allow-multidot -allow-leading-dots -no-bak \
        -o /config/workspace/kickstart/bulid/universal/finish/centos7-universal.iso \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v \
        -T /config/workspace/kickstart/mkisofs
}
__mkisofs

__scp() {
    # 通过 scp 将文件上传到 其他设备,尝试安装
    scp /config/workspace/kickstart/bulid/universal/finish/centos7-universal.iso root@10.32.255.253:/A/Hyper-V/iso/centos7-universal.iso
}
__scp
