#!/bin/bash
# set -x

USAGE="
Usage:
update-swagger-ui.sh -v <SWAGGER_UI_VERSION>
update-swagger-ui.sh -h (or --help)
"

version=""
lastest_version=""
while getopts "v:h" arg
do
    case $arg in
        v) version=$2; shift 2;;
        h) echo "${USAGE}"; exit 0;;
        ?) echo "args error: $1"; exit 1;;
    esac
done

echo ${version}


_get_latest_version() {
lastest_version="$(curl -H 'Cache-Control: no-cache' -s https://api.github.com/repos/swagger-api/swagger-ui/releases/latest | grep 'tag_name' | cut -d \" -f4)"

if [[ ! $lastest_version ]]; then
    echo
    echo -e " 获取 V2Ray 最新版本失败!!!"
    echo
    exit 1
fi
}

download_lastest_version() {
    # 若未提供版本，则查找最新版本
    if [[ ! $version ]]; then
        _get_latest_version
        version=${lastest_version##*v}
        while :; do
            read -p "目前最新的 swagger-ui 版本为: ${lastest_version}, 是否更新(y/n)" _opt
            
            if [[ -z $_opt ]]; then
                echo "输入错误"
            else
                case $_opt in
                    y)
                        break
                        ;;
                    n)
                        exit 1
                        ;;
                    *)
                        echo "输入错误"
                        ;;
                esac
            fi
        done

    fi
    
    archive="https://github.com/swagger-api/swagger-ui/archive/v${version}.tar.gz"
    
    folder="swagger-ui-${version}"
    rm -rf "${folder}" && mkdir -p "${folder}"
    wget $archive -O - | tar -xvz -C "$folder" --strip-components=1
    
    # folder="swagger-ui-3.19.3"
    # 删除旧文件，复制下载的文件到 assets 目录
    rm -rf ./assets/*
    cp ${folder}/LICENSE ./assets/
    cp ${folder}/dist/* ./assets/
    
    # -i '' 兼容mac，表示不备份
    sed -i '' 's#src="\.#src="/assets#g' ./assets/index.html
    sed -i '' 's#href="\.#href="/assets#g' ./assets/index.html
    sed -i '' 's#https://petstore.swagger.io/v[1-9]/swagger.json#index.yaml#g' ./assets/index.html
    
    rm -fr "$folder"
}

download_lastest_version

