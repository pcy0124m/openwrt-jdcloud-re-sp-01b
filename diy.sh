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

# 添加 helloworld 插件源 (Passwall、OpenClaw 等)
if [ ! -f "feeds.conf.default" ]; then
    cp feeds.conf.default feeds.conf
fi
grep -q "helloworld" feeds.conf || echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf

# 添加 passwall 插件源
grep -q "passwall" feeds.conf || echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >> feeds.conf

# 添加 passwall2 插件源
grep -q "passwall2" feeds.conf || echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2' >> feeds.conf

echo "=== diy.sh 执行完成 ==="
