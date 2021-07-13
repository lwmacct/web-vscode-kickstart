#!/usr/bin/env bash
exit 0
git config --global user.name "lwmacct"
git config --global user.email "lwmacct@163.com"



cd /config
rm -rf .git
git init
git remote add origin git@gitee.com:lwmacct/web-vscode-kickstart.git
git remote set-url --add origin git@github.com:lwmacct/web-vscode-kickstart.git

git lfs install
git lfs track "*.tar.gz"
git lfs track "*.rpm"
git add /config/.gitattributes
git config lfs.https://github.com/lwmacct/web-vscode-kickstart.git/info/lfs.locksverify false
