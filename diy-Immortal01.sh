#!/bin/bash

# 确保 smartdns 源码已拉取
git clone https://github.com/pymumu/smartdns.git package/smartdns
# Add third-party feeds
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> feeds.conf.default
echo "src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome.git;master" >> feeds.conf.default
echo "src-git smartdns https://github.com/pymumu/smartdns.git;master" >> feeds.conf.default
echo "src-git lucky https://github.com/sirpdboy/luci-app-lucky.git;main" >> feeds.conf.default
echo "src-git ksmbd https://github.com/openwrt/luci-app-ksmbd.git;master" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a -f

# Fix dnsmasq conflict
rm -rf feeds/packages/net/dnsmasq
git clone https://github.com/openwrt/packages.git -b openwrt-22.03 packages-temp
cp -r packages-temp/net/dnsmasq feeds/packages/net/
rm -rf packages-temp

# Ensure docker-compose
if [ ! -d feeds/packages/utils/docker-compose ]; then
    git clone https://github.com/openwrt/packages.git -b openwrt-22.03 packages-temp
    cp -r packages-temp/utils/docker-compose feeds/packages/utils/
    rm -rf packages-temp
fi
