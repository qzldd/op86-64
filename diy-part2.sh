#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 移除要替换的包
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
# 添加温度显示
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
# Modify default IP
sed -i 's/192.168.1.1/10.0.0.10/g' package/base-files/files/bin/config_generate
# 修改输出文件名
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=full-$(shell date +%Y%m%d)-$(VERSION_DIST_SANITIZED)/g' include/image.mk
# 修改系统版本号
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
export orig_version="$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')"
sed -i "s/${orig_version}/${orig_version} ($(date +"%Y-%m-%d"))/g" zzz-default-settings
popd

# 修改默认主题
#sed -i 's/luci-theme-bootstrap/luci-theme-Argon/g' feeds/luci/collections/luci/Makefile
#修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# passwall
rm -rf feeds/luci/applications/luci-app-passwall/
rm -rf feeds/packages/net/xray-core/
rm -rf feeds/packages/net/xray-plugin/
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall

########### 更改大雕源码（可选）20220712增加###########
sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.6/g' target/linux/x86/Makefile

########### 更新lean的内置的smartdns版本20230909注释掉了 ###########
sed -i 's/1.2023.42/1.2024.46/g' feeds/packages/net/smartdns/Makefile
sed -i 's/ed102cda03c56e9c63040d33d4a391b56491493e/07c13827bb523519a638214ed7ad76180f71a40a/g' feeds/packages/net/smartdns/Makefile
sed -i 's/^PKG_MIRROR_HASH/#&/' feeds/packages/net/smartdns/Makefile


#添加额外非必须软件包####20230909加入第一行原来是释掉的 
#git clone https://github.com/pymumu/smartdns.git package/smartdns
#git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
#git clone --branch lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

#添加大吉
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

#新加入插件第二部分
pushd package/lean
# SmartDNS

#git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns
#git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/lisaac/luci-app-dockerman
#cp -f $GITHUB_WORKSPACE/general/qBittorrent/Makefile feeds/packages/net/qBittorrent/Makefile
popd 
