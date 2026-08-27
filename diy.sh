#!/bin/bash

#
# diy.sh - JDCloud RE-SP-01B 自定义脚本
#

echo "=== 开始执行 diy.sh ==="

# 强制禁用 libselinux (mt7621 编译失败, 路由器不需要 SELinux)
# 物理删除源码目录, 彻底阻止编译 (config 里设 =n 无法对抗 kconfig 依赖链)
echo "--- 禁用 libselinux ---"
if [ -d "package/libs/libselinux" ]; then
    rm -rf package/libs/libselinux
    echo "[OK] 已删除 package/libs/libselinux"
else
    echo "[INFO] libselinux 目录不存在 (可能已被移除)"
fi

# 修复: 删除 Lean 源码中与当前内核不兼容的坏补丁（已知问题，内核更新后 hunk 失败）
# 这些补丁是给京东云一代特定硬件（摄像头/红外遥控）打的，路由器用途不需要
echo "--- 清理不兼容的内核补丁 ---"
echo "[DEBUG] 当前工作目录: $(pwd)"
echo "[DEBUG] 列出 ramips 补丁目录:"
ls -la target/linux/ramips/patches-5.10/ 2>/dev/null | head -30 || echo "[DEBUG] patches-5.10 目录不存在"
echo "[DEBUG] 搜索所有含 uvc/ip209/iPassion 的文件:"
find target/linux/ramips -type f \( -iname "*uvc*" -o -iname "*ip209*" -o -iname "*ipassion*" \) 2>/dev/null || echo "[DEBUG] 未找到"
echo "[DEBUG] 搜索所有含 ir-rc 的文件:"
find target/linux/ramips -type f -iname "*ir-rc*" 2>/dev/null || echo "[DEBUG] 未找到"
# 执行删除
rm -vf target/linux/ramips/patches-5.10/810-uvc-add-iPassion-IP209-support.patch 2>/dev/null || true
find target/linux/ramips/patches-5.10 -iname "*ir-rc*" -type f -exec rm -vf {} \; 2>/dev/null || true
find target/linux \( -iname "*uvc*ip209*" -o -iname "*ipassion*uvc*" \) -type f -exec rm -vf {} \; 2>/dev/null || true
echo "[DEBUG] 再次确认: 搜索结果应为空"
find target/linux -type f \( -iname "*uvc*ip209*" -o -iname "*ipassion*uvc*" -o -iname "*ir-rc*v*support*" \) 2>/dev/null && echo "[WARN] 还有残留!" || echo "[OK] 已全部清除"
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
