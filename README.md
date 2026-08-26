# OpenWrt 云编译仓库 - 京东云无线宝一代

本项目使用 GitHub Actions 云编译京东云无线宝一代（RE-SP-01B）的 OpenWrt 固件。

## 硬件规格

- CPU: MediaTek MT7621AT (双核 880MHz)
- RAM: 512MB
- Flash: 32MB NOR + eMMC (64GB/128GB)
- WiFi: 2.4GHz 2×2 + 5GHz 4×4 (WiFi 5)
- 网口: 4×千兆 LAN/WAN, 1×USB 2.0

## 固件信息

- 默认管理地址: `http://192.168.1.1`
- 默认用户名: `root`
- 默认密码: `password`

## 已集成插件

- LuCI 中文界面
- Passwall / Passwall2 (代理)
- Docker
- AdGuard Home (去广告)
- 文件系统支持 (ext4, ntfs)
- WireGuard VPN
- Samba 文件共享
- 主题: Argon / Netgear

## 如何使用

1. Fork 本仓库
2. 修改 `config/jdcloud-re-sp-01b.config` 添加/删除插件
3. 修改 `diy.sh` 自定义设置
4. 进入 Actions 页面，点击 Run workflow
5. 编译完成后下载固件

## 编译时间

约 40-90 分钟（取决于插件数量）

## 刷入方法

1. 先刷入 Breed 不死引导
2. 进入 Breed Web 界面 (192.168.1.1)
3. 上传固件，自动重启

## 参考资源

- P3TERX/Actions-OpenWrt: https://github.com/P3TERX/Actions-OpenWrt
- Lean LEDE: https://github.com/coolsnowwolf/lede
- 恩山论坛: https://www.right.com.cn/forum/
