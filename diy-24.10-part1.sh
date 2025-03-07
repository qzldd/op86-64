#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-24.10-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Add a feed source
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' >>feeds.conf.default
echo 'src-git smartdns_luci https://github.com/pymumu/luci-app-smartdns;lede' >>feeds.conf.default

# --- 修改处开始 ---
# 修改 sysupgrade.conffiles，添加需要保留的文件
echo "/etc/config/dockerd" >> package/system/procd/files/sysupgrade.conffiles
echo "/opt/qBittorrent/qBittorrent/cache/" >> package/system/procd/files/sysupgrade.conffiles
echo "/opt/qBittorrent/qBittorrent/config/" >> package/system/procd/files/sysupgrade.conffiles
echo "/opt/qBittorrent/qBittorrent/data/" >> package/system/procd/files/sysupgrade.conffiles
# --- 修改处结束 ---

# Update and install feeds with error handling
./scripts/feeds update -a || echo "Feed update failed, but continuing..."
./scripts/feeds install -a
