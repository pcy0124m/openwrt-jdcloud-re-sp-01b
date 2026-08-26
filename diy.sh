#!/bin/bash

#
# diy.sh - JDCloud RE-SP-01B 自定义脚本
#

echo "=== 开始执行 diy.sh ==="

# 修复: 删除与当前内核不兼容的 UVC IP209 补丁（Lean 源码已知问题）
# 实际文件名: 810-uvc-add-iPassion-IP209-support.patch（注意: 编号810不是818，含iPassion大写P）
# 该补丁给京东云一代 USB 摄像头驱动打补丁，但内核更新后 hunk 失败导致编译中断
echo "--- 查找并删除 UVC IP209 坏补丁 ---"
# 方法1: 精确文件名（已知路径）
rm -vf target/linux/ramips/patches-5.10/810-uvc-add-iPassion-IP209-support.patch 2>/dev/null || true
# 方法2: 不区分大小写全局搜索兜底
find target/linux -iname "*uvc*ip209*" -o -iname "*ipassion*uvc*" 2>/dev/null | while read f; do
    echo "找到并删除: $f"
    rm -f "$f"
done
echo "--- UVC 补丁清理完成 ---"

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
