#!/usr/bin/env bash

__init_ln() {
    # 将 $HOME 下一些常修改的文件链接过来,方便编辑
    mkdir -p /config/workspace/.vscode-ln/
    _list="/config/.gitconfig /config/.gitignore /config/README.md /config/.gitattributes"

    for _item in $_list; do
        echo "${_item}"
        if [ ! -f "$_item" ]; then
            echo '' >"$_item"
        fi
        _file=$(echo "$_item" | awk -F '/' '{print $NF}')
        ln -sf "$_item" "/config/workspace/.vscode-ln/$_file"

    done

}
__init_ln
