#!/bin/bash

#
# diy.sh - JDCloud RE-SP-01B 自定义脚本
#

echo "=== 开始执行 diy.sh ==="

# 修复: 删除 Lean 源码中与当前内核不兼容的坏补丁（已知问题，内核更新后 hunk 失败）
# 这些补丁是给京东云一代特定硬件（摄像头/红外遥控）打的，路由器用途不需要
echo "--- 清理不兼容的内核补丁 ---"
# 坏补丁1: UVC IP209 摄像头驱动补丁
rm -vf target/linux/ramips/patches-5.10/810-uvc-add-iPassion-IP209-support.patch 2>/dev/null || true
# 坏补丁2: IR 红外遥控支持补丁
find target/linux/ramips/patches-5.10 -iname "*ir-rc*" -type f 2>/dev/null | while read f; do
    echo "删除 IR 补丁: $f"
    rm -f "$f"
done
# 兜底：不区分大小写全局搜索所有已知的坏补丁模式
find target/linux \( -iname "*uvc*ip209*" -o -iname "*ipassion*uvc*" -o -iname "*ir-rc*v*support*" \) -type f 2>/dev/null | while read f; do
    echo "兜底删除: $f"
    rm -f "$f"
done
echo "--- 内核补丁清理完成 ---"

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
