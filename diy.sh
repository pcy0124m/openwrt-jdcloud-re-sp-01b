#!/bin/bash

#
# diy.sh - 官方 OpenWrt 源码自定义脚本 (JDCloud RE-SP-01B)
#
# 说明:
#  - 官方源码已原生支持 jdcloud_re-sp-01b (commit c35f2a23, 25.12.0+)
#  - 无需禁用 default-settings / libselinux 等 Lean 补丁问题
#  - 只做必要的默认配置修改
#

echo "=== 开始执行 diy.sh (官方 OpenWrt) ==="

# 修改默认主机名为 JDCloud
sed -i 's/OpenWrt/JDCloud/g' package/base-files/files/bin/config_generate

# 修改时区为上海
sed -i 's|Timezone.*|Timezone "Asia/Shanghai"|g' package/base-files/files/bin/config_generate

# 设置默认 LuCI 主题为 Argon (需要 later feeds 添加)
mkdir -p package/base-files/files/etc/uci-defaults/
cat > package/base-files/files/etc/uci-defaults/99-set-luci-theme << 'EOF'
#!/bin/sh
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-set-luci-theme

# 添加 helloworld 插件源 (Passwall, OpenClash 等)
if [ ! -f "feeds.conf.default" ]; then
    cp feeds.conf.default feeds.conf
fi
grep -q "helloworld" feeds.conf || echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf

echo "=== diy.sh 执行完成 ==="
