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

# 修改openwrt登陆地址,把下面的 192.168.2.1 修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
#sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate

# 修改子网掩码
#sed -i 's/255.255.255.0/255.255.0.0/g' package/base-files/files/bin/config_generate

# 默认打开WiFi
#sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 清除默认登录密码
sed -i 's/$1$5mjCdAB1$Uk1sNbwoqfHxUmzRIeuZK1:0/:/g' package/base-files/files/etc/shadow

# ttyd 自动登录
#sed -i "s?/bin/login?/usr/libexec/login.sh?g" package/feeds/packages/ttyd/files/ttyd.config
# 修改 WiFi 名称
# sed -i 's/OpenWrt/OpenWrt/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 默认打开 WiFi
#sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#修改分区大小
#sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=256/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/g' .config

# 移除要替换的包
rm -rf feeds/third_party/luci-app-LingTiGameAcc
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-adguardhome
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-openclash
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-aliddns
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-filebrowser filebrowser
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-jellyfin luci-lib-taskd

# 科学上网插件
git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
#git clone https://github.com/1wrt/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-adbyby-plus
# 在线用户
git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh


# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
$GITHUB_WORKSPACE/preset-clash-core.sh

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/argon/img/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/argon/img/argon.svg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/argon.svg
cp -f $GITHUB_WORKSPACE/argon/background/background.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/background.jpg
cp -f $GITHUB_WORKSPACE/argon/favicon.ico feeds/third/luci-theme-argon/htdocs/luci-static/argon/favicon.ico
cp -f $GITHUB_WORKSPACE/argon/icon/android-icon-192x192.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/android-icon-192x192.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-144x144.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-144x144.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-60x60.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-60x60.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-72x72.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-72x72.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-16x16.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-16x16.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-32x32.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-32x32.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-96x96.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-96x96.png
cp -f $GITHUB_WORKSPACE/argon/icon/ms-icon-144x144.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/ms-icon-144x144.png

echo "
# 额外组件
CONFIG_GRUB_IMAGES=y
CONFIG_VMDK_IMAGES=y

# 添加自定义软件包

# openclash
CONFIG_PACKAGE_luci-app-openclash=y

# adguardhome
CONFIG_PACKAGE_luci-app-adguardhome=y

# mosdns
#CONFIG_PACKAGE_luci-app-mosdns=y

# pushbot
CONFIG_PACKAGE_luci-app-pushbot=y

# Jellyfin
#CONFIG_PACKAGE_luci-app-jellyfin=y

# qbittorrent
#CONFIG_PACKAGE_luci-app-qbittorrent=y

# transmission
#CONFIG_PACKAGE_luci-app-transmission=y
#CONFIG_PACKAGE_transmission-web-control=y

# 关机
CONFIG_PACKAGE_luci-app-poweroff=y
#CONFIG_PACKAGE_luci-i18n-poweroff-zh-cn=y

# uhttpd
#CONFIG_PACKAGE_luci-app-uhttpd=y

# 阿里DDNS
#CONFIG_PACKAGE_luci-app-aliddns=y

# filebrowser
CONFIG_PACKAGE_luci-app-filebrowser=y

#SSR-PLUS
#CONFIG_PACKAGE_luci-app-ssr-plus=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_libustream-openssl=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Server=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Xray=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_MosDNS=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Client=y
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Server=y

#passwall
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-i18n-passwall-zh-cn=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Kcptun=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_PDNSD=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_GO=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=y

#passwall2
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Brook=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Haproxy is not set
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_IPv6_Nat=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_tuic_client=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray_Plugin is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=y

# 科学上网-bypass
CONFIG_PACKAGE_lua-maxminddb=y
CONFIG_PACKAGE_luci-app-bypass=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Simple_obfs=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Simple_obfs_server=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_V2ray_plugin is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Trojan=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_NaiveProxy is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Kcptun=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Socks5_Proxy=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Socks_Server=y

# docker应用
# CONFIG_PACKAGE_luci-app-aliyundrive-webdav=y
# CONFIG_PACKAGE_luci-app-aria2=y
# CONFIG_PACKAGE_luci-app-transmission=y
# CONFIG_PACKAGE_luci-app-qbittorrent=y
# CONFIG_PACKAGE_luci-app-qbittorrent_static=y
# CONFIG_PACKAGE_luci-app-alist=y
# CONFIG_PACKAGE_luci-app-filebrowser=y
# CONFIG_PACKAGE_luci-app-familycloud=y
# CONFIG_PACKAGE_luci-app-kodexplorer=y
# CONFIG_PACKAGE_luci-app-rclone=y

#iKoolProxy
CONFIG_PACKAGE_luci-app-iKoolProxy=y
CONFIG_PACKAGE_iptables-mod-nat-extra=y
CONFIG_PACKAGE_kmod-ipt-extra=y
CONFIG_PACKAGE_diffutils=y
CONFIG_PACKAGE_openssl-util=y
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_ca-bundle=y
CONFIG_PACKAGE_ca-certificates=y
CONFIG_PACKAGE_libustream-openssl=n
CONFIG_PACKAGE_lua-openssl=y

# 内网穿透
# CONFIG_PACKAGE_luci-app-zerotier=y
# CONFIG_PACKAGE_luci-app-frpc=y
# CONFIG_PACKAGE_luci-app-frps=y
# CONFIG_PACKAGE_luci-app-nps=y
# CONFIG_PACKAGE_luci-app-n2n_v2=y

#adbyby
CONFIG_PACKAGE_luci-app-adbyby-plus=y
CONFIG_PACKAGE_luci-i18n-adbyby-plus-zh-cn=y
#CONFIG_PACKAGE_adbyby=y

#补充网卡
CONFIG_PACKAGE_kmod-ath=y
CONFIG_PACKAGE_kmod-ath10k=y
CONFIG_PACKAGE_ath10k-board-qca9888=y
CONFIG_PACKAGE_ath10k-board-qca988x=y
CONFIG_PACKAGE_ath10k-board-qca9984=y
CONFIG_PACKAGE_ath10k-firmware-qca9888=y
CONFIG_PACKAGE_ath10k-firmware-qca988x=y
CONFIG_PACKAGE_ath10k-firmware-qca9984=y

" >> .config
