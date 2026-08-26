#!/bin/bash

#
# diy.sh - JDCloud RE-SP-01B 自定义脚本
#

echo "=== 开始执行 diy.sh ==="

# 修改默认 IP (可选，默认 192.168.1.1)
# sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i 's/OpenWrt/JDCloud/g' package/base-files/files/bin/config_generate

# 修改时区为上海
sed -i 's|Timezone.*|Timezone "Asia/Shanghai"|g' package/base-files/files/bin/config_generate

# 添加 helloworld 插件源 (包含 Passwall、OpenClash 等常用插件)
# 注意: 不单独添加 passwall/passwall2 源，避免 feed 名称冲突导致构建失败
# 如需 Passwall，通过 helloworld 源即可获取
if [ ! -f "feeds.conf.default" ]; then
    cp feeds.conf.default feeds.conf
fi
grep -q "helloworld" feeds.conf || echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf

echo "=== diy.sh 执行完成 ==="
