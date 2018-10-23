#
# Copyright (C) 2012-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nginx
PKG_VERSION:=1.15.5
PKG_RELEASE:=1

PKG_SOURCE:=nginx-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://nginx.org/download/
PKG_HASH:=1a3a889a8f14998286de3b14cc1dd5b2747178e012d6d480a18aa413985dae6f

PKG_MAINTAINER:=Thomas Heil <heil@terminal-consulting.de> \
				Ansuel Smith <ansuelsmth@gmail.com>
PKG_LICENSE:=2-clause BSD-like license

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

PKG_CONFIG_DEPENDS := \
	CONFIG_NGINX_SSL \
	CONFIG_NGINX_DAV \
	CONFIG_NGINX_FLV \
	CONFIG_NGINX_STUB_STATUS \
	CONFIG_NGINX_HTTP_CHARSET \
	CONFIG_NGINX_HTTP_GZIP \
	CONFIG_NGINX_HTTP_SSI \
	CONFIG_NGINX_HTTP_USERID \
	CONFIG_NGINX_HTTP_ACCESS \
	CONFIG_NGINX_HTTP_AUTH_BASIC \
	CONFIG_NGINX_HTTP_AUTH_REQUEST \
	CONFIG_NGINX_HTTP_AUTOINDEX \
	CONFIG_NGINX_HTTP_GEO \
	CONFIG_NGINX_HTTP_MAP \
	CONFIG_NGINX_HTTP_SPLIT_CLIENTS \
	CONFIG_NGINX_HTTP_REFERER \
	CONFIG_NGINX_HTTP_REWRITE \
	CONFIG_NGINX_HTTP_PROXY \
	CONFIG_NGINX_HTTP_FASTCGI \
	CONFIG_NGINX_HTTP_UWSGI \
	CONFIG_NGINX_HTTP_SCGI \
	CONFIG_NGINX_HTTP_MEMCACHED \
	CONFIG_NGINX_HTTP_LIMIT_CONN \
	CONFIG_NGINX_HTTP_LIMIT_REQ \
	CONFIG_NGINX_HTTP_EMPTY_GIF \
	CONFIG_NGINX_HTTP_BROWSER \
	CONFIG_NGINX_HTTP_UPSTREAM_HASH \
	CONFIG_NGINX_HTTP_UPSTREAM_IP_HASH \
	CONFIG_NGINX_HTTP_UPSTREAM_LEAST_CONN \
	CONFIG_NGINX_HTTP_UPSTREAM_KEEPALIVE \
	CONFIG_NGINX_HTTP_UPSTREAM_ZONE \
	CONFIG_NGINX_HTTP_CACHE \
	CONFIG_NGINX_HTTP_V2 \
	CONFIG_NGINX_PCRE \
	CONFIG_NGINX_NAXSI \
	CONFIG_NGINX_LUA \
	CONFIG_NGINX_HTTP_REAL_IP \
	CONFIG_NGINX_HTTP_SECURE_LINK \
	CONFIG_NGINX_HTTP_BROTLI \
	CONFIG_NGINX_HEADERS_MORE \
	CONFIG_NGINX_RTMP_MODULE \
	CONFIG_NGINX_TS_MODULE \

include $(INCLUDE_DIR)/package.mk

define Package/nginx/default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Nginx web server
  URL:=http://nginx.org/
  DEPENDS:=+NGINX_PCRE:libpcre +(NGINX_SSL||NGINX_HTTP_CACHE||NGINX_HTTP_AUTH_BASIC):libopenssl \
	+NGINX_HTTP_GZIP:zlib +NGINX_LUA:liblua +libpthread +NGINX_DAV:libexpat
endef

define Package/nginx/description
 nginx is an HTTP and reverse proxy server, as well as a mail proxy server, \
 written by Igor Sysoev. (Some module require SSL module enable to show up in \
 config menu)
endef

define Package/nginx
  $(Package/nginx/default)
  VARIANT:=no-ssl
endef

define Package/nginx-ssl
  $(Package/nginx/default)
  TITLE += with SSL support
  DEPENDS +=+libopenssl
  VARIANT:=ssl
  PROVIDES:=nginx
endef

Package/nginx-ssl/description = $(Package/nginx/description) \
  This varian is compiled with SSL support enabled. To enable additional module \
  select them in the nginx default configuration menu.

define Package/nginx-all-module
  $(Package/nginx/default)
  TITLE += with ALL module selected
  DEPENDS:=+libpcre +libopenssl +zlib +liblua +libpthread +libexpat
  VARIANT:=all-module
  PROVIDES:=nginx
endef

Package/nginx-all-module/description = $(Package/nginx/description) \
  This varian is compiled with ALL module selected.

define Package/nginx/config
  source "$(SOURCE)/Config.in"
endef

define Package/nginx-ssl/config
  source "$(SOURCE)/Config_ssl.in"
endef

config_files=nginx.conf mime.types

define Package/nginx/conffiles
/etc/nginx/
endef

Package/nginx-ssl/conffiles = $(Package/nginx/conffiles)
Package/nginx-all-module/conffiles = $(Package/nginx/conffiles)


ADDITIONAL_MODULES:=

ifneq ($(BUILD_VARIANT),all-module)
  ifneq ($(CONFIG_NGINX_HTTP_CACHE),y)
    ADDITIONAL_MODULES += --without-http-cache
  endif
  ifneq ($(CONFIG_NGINX_PCRE),y)
    ADDITIONAL_MODULES += --without-pcre
  endif
  ifneq ($(CONFIG_NGINX_HTTP_CHARSET),y)
    ADDITIONAL_MODULES += --without-http_charset_module
  else
    config_files += koi-utf koi-win win-utf
  endif
  ifneq ($(CONFIG_NGINX_HTTP_GZIP),y)
    ADDITIONAL_MODULES += --without-http_gzip_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_SSI),y)
    ADDITIONAL_MODULES += --without-http_ssi_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_USERID),y)
    ADDITIONAL_MODULES += --without-http_userid_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_ACCESS),y)
    ADDITIONAL_MODULES += --without-http_access_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_AUTH_BASIC),y)
    ADDITIONAL_MODULES += --without-http_auth_basic_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_AUTOINDEX),y)
    ADDITIONAL_MODULES += --without-http_autoindex_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_GEO),y)
    ADDITIONAL_MODULES += --without-http_geo_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_MAP),y)
    ADDITIONAL_MODULES += --without-http_map_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_SPLIT_CLIENTS),y)
    ADDITIONAL_MODULES += --without-http_split_clients_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_REFERER),y)
    ADDITIONAL_MODULES += --without-http_referer_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_REWRITE),y)
    ADDITIONAL_MODULES += --without-http_rewrite_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_PROXY),y)
    ADDITIONAL_MODULES += --without-http_proxy_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_FASTCGI),y)
    ADDITIONAL_MODULES += --without-http_fastcgi_module
  else
    config_files += fastcgi_params
  endif
  ifneq ($(CONFIG_NGINX_HTTP_UWSGI),y)
    ADDITIONAL_MODULES += --without-http_uwsgi_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_SCGI),y)
    ADDITIONAL_MODULES += --without-http_scgi_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_MEMCACHED),y)
    ADDITIONAL_MODULES += --without-http_memcached_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_LIMIT_CONN),y)
    ADDITIONAL_MODULES += --without-http_limit_conn_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_LIMIT_REQ),y)
    ADDITIONAL_MODULES += --without-http_limit_req_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_EMPTY_GIF),y)
    ADDITIONAL_MODULES += --without-http_empty_gif_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_BROWSER),y)
    ADDITIONAL_MODULES += --without-http_browser_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_UPSTREAM_HASH),y)
    ADDITIONAL_MODULES += --without-http_upstream_hash_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_UPSTREAM_IP_HASH),y)
    ADDITIONAL_MODULES += --without-http_upstream_ip_hash_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_UPSTREAM_LEAST_CONN),y)
    ADDITIONAL_MODULES += --without-http_upstream_least_conn_module
  endif
  ifneq ($(CONFIG_NGINX_HTTP_UPSTREAM_KEEPALIVE),y)
    ADDITIONAL_MODULES += --without-http_upstream_keepalive_module
  endif
  
  ifeq ($(BUILD_VARIANT),ssl)
    ifneq ($(CONFIG_NGINX_SSL),y)
      ADDITIONAL_MODULES += --with-http_ssl_module
    endif
  endif
  
  ifeq ($(CONFIG_NGINX_SSL),y)
    ADDITIONAL_MODULES += --with-http_ssl_module
  endif
  ifeq ($(CONFIG_NGINX_NAXSI),y)
    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-naxsi/naxsi_src
  endif
  ifeq ($(CONFIG_NGINX_LUA),y)
    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/lua-nginx
  endif
  ifeq ($(CONFIG_IPV6),y)
    ADDITIONAL_MODULES += --with-ipv6
  endif
  ifeq ($(CONFIG_NGINX_STUB_STATUS),y)
    ADDITIONAL_MODULES += --with-http_stub_status_module
  endif
  ifeq ($(CONFIG_NGINX_FLV),y)
    ADDITIONAL_MODULES += --with-http_flv_module
  endif
  ifeq ($(CONFIG_NGINX_DAV),y)
    ADDITIONAL_MODULES += --with-http_dav_module --add-module=$(PKG_BUILD_DIR)/nginx-dav-ext-module
  endif
  ifeq ($(CONFIG_NGINX_HTTP_AUTH_REQUEST),y)
    ADDITIONAL_MODULES += --with-http_auth_request_module
  endif
  ifeq ($(CONFIG_NGINX_HTTP_V2),y)
    ADDITIONAL_MODULES += --with-http_v2_module
  endif
  ifeq ($(CONFIG_NGINX_HTTP_REAL_IP),y)
    ADDITIONAL_MODULES += --with-http_realip_module
  endif
  ifeq ($(CONFIG_NGINX_HTTP_SECURE_LINK),y)
    ADDITIONAL_MODULES += --with-http_secure_link_module
  endif
  ifeq ($(CONFIG_NGINX_HTTP_SUB),y)
	ADDITIONAL_MODULES += --with-http_sub_module
  endif
  ifeq ($(CONFIG_NGINX_HEADERS_MORE),y)
    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-headers-more
  endif
  ifeq ($(CONFIG_NGINX_HTTP_BROTLI),y)
    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-brotli
  endif
  ifeq ($(CONFIG_NGINX_RTMP_MODULE),y)
    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-rtmp
  endif
  ifeq ($(CONFIG_NGINX_TS_MODULE),y)
    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-ts
  endif
else
  CONFIG_NGINX_HEADERS_MORE:=y
  CONFIG_NGINX_HTTP_BROTLI:=y
  CONFIG_NGINX_RTMP_MODULE:=y
  CONFIG_NGINX_TS_MODULE:=y
  CONFIG_NGINX_NAXSI:=y
  CONFIG_NGINX_LUA:=y
  CONFIG_NGINX_DAV:=y
  ADDITIONAL_MODULES += --with-http_ssl_module --add-module=$(PKG_BUILD_DIR)/nginx-naxsi/naxsi_src \
    --add-module=$(PKG_BUILD_DIR)/lua-nginx --with-ipv6 --with-http_stub_status_module --with-http_flv_module \
	--with-http_dav_module --add-module=$(PKG_BUILD_DIR)/nginx-dav-ext-module \
	--with-http_auth_request_module --with-http_v2_module --with-http_realip_module \
	--with-http_secure_link_module --with-http_sub_module --add-module=$(PKG_BUILD_DIR)/nginx-headers-more \
	--add-module=$(PKG_BUILD_DIR)/nginx-brotli --add-module=$(PKG_BUILD_DIR)/nginx-rtmp \
	--add-module=$(PKG_BUILD_DIR)/nginx-ts
  config_files += koi-utf koi-win win-utf fastcgi_params 
endif

define Package/nginx-mod-luci/default
  TITLE:=Nginx on LuCI
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Support file for Nginx
  URL:=http://nginx.org/
  DEPENDS:=+uwsgi-cgi +uwsgi-cgi-luci-support
endef

define Package/nginx-mod-luci
  $(Package/nginx-mod-luci/default)
  DEPENDS += +nginx
endef

define Package/nginx-mod-luci/description
 Support file for LuCI in nginx. Include custom nginx configuration, autostart script for uwsgi.
endef

define Package/nginx-mod-luci-ssl
  $(Package/nginx-mod-luci/default)
  TITLE += with HTTPS support
  DEPENDS += +nginx-ssl
endef

Package/nginx-mod-luci-ssl/description = $(define Package/nginx-mod-luci/description) \
  This also include redirect from http to https and cert autogeneration.

TARGET_CFLAGS += -fvisibility=hidden -ffunction-sections -fdata-sections -DNGX_LUA_NO_BY_LUA_BLOCK
TARGET_LDFLAGS += -Wl,--gc-sections

ifeq ($(CONFIG_NGINX_LUA),y)
  CONFIGURE_VARS += LUA_INC=$(STAGING_DIR)/usr/include \
					LUA_LIB=$(STAGING_DIR)/usr/lib
endif

CONFIGURE_ARGS += \
			--crossbuild=Linux::$(ARCH) \
			--prefix=/usr \
			--conf-path=/etc/nginx/nginx.conf \
			$(ADDITIONAL_MODULES) \
			--error-log-path=/var/log/nginx/error.log \
			--pid-path=/var/run/nginx.pid \
			--lock-path=/var/lock/nginx.lock \
			--http-log-path=/var/log/nginx/access.log \
			--http-client-body-temp-path=/var/lib/nginx/body \
			--http-proxy-temp-path=/var/lib/nginx/proxy \
			--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
			--with-cc="$(TARGET_CC)" \
			--with-cc-opt="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS)" \
			--with-ld-opt="$(TARGET_LDFLAGS)" \
			--without-http_upstream_zone_module

define Package/nginx-mod-luci/install
	$(INSTALL_DIR) $(1)/etc/nginx
	$(INSTALL_BIN) ./files-luci-support/luci_uwsgi.conf $(1)/etc/nginx/luci_uwsgi.conf
	$(INSTALL_BIN) ./files-luci-support/luci_nginx.conf $(1)/etc/nginx/luci_nginx.conf
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files-luci-support/60_nginx-luci-support $(1)/etc/uci-defaults/60_nginx-luci-support
endef

define Package/nginx-mod-luci-ssl/install
	$(Package/nginx-mod-luci/install)
	$(INSTALL_DIR) $(1)/etc/nginx
	$(INSTALL_BIN) ./files-luci-support/luci_nginx_ssl.conf $(1)/etc/nginx/luci_nginx_ssl.conf
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files-luci-support/70_nginx-luci-support-ssl $(1)/etc/uci-defaults/70_nginx-luci-support-ssl
endef

define Package/nginx/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/nginx $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/nginx
	$(INSTALL_DATA) $(addprefix $(PKG_INSTALL_DIR)/etc/nginx/,$(config_files)) $(1)/etc/nginx/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/nginx.init $(1)/etc/init.d/nginx
ifeq ($(CONFIG_NGINX_NAXSI),y)
	$(INSTALL_DIR) $(1)/etc/nginx
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nginx-naxsi/naxsi_config/naxsi_core.rules $(1)/etc/nginx
	chmod 0640 $(1)/etc/nginx/naxsi_core.rules
endif
	$(if $(CONFIG_NGINX_NAXSI),$($(INSTALL_BIN) $(PKG_BUILD_DIR)/nginx-naxsi/naxsi_config/naxsi_core.rules $(1)/etc/nginx))
	$(if $(CONFIG_NGINX_NAXSI),$(chmod 0640 $(1)/etc/nginx/naxsi_core.rules))
endef

Package/nginx-ssl/install = $(Package/nginx/install)
Package/nginx-all-module/install = $(Package/nginx/install)

define Build/Prepare
	$(Build/Prepare/Default)
	$(Prepare/nginx-naxsi)
	$(Prepare/lua-nginx)
	$(Prepare/nginx-brotli)
	$(Prepare/nginx-headers-more)
	$(Prepare/nginx-rtmp)
	$(Prepare/nginx-ts)
	$(Prepare/nginx-dav-ext-module)
endef


ifeq ($(CONFIG_NGINX_HEADERS_MORE),y)
  define Download/nginx-headers-more
    VERSION:=a9f7c7e86cc7441d04e2f11f01c2e3a9c4b0301d
    SUBDIR:=nginx-headers-more
    FILE:=headers-more-nginx-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/openresty/headers-more-nginx-module.git
    MIRROR_HASH:=432609015719aaa7241e5166c7cda427acbe004f725887f78ef629d51bd9cb3f
    PROTO:=git
  endef
  $(eval $(call Download,nginx-headers-more))

  define Prepare/nginx-headers-more
	$(eval $(Download/nginx-headers-more))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
  endef
endif


ifeq ($(CONFIG_NGINX_HTTP_BROTLI),y)
  define Download/nginx-brotli
    VERSION:=e26248ee361c04e25f581b92b85d95681bdffb39
    SUBDIR:=nginx-brotli
    FILE:=ngx-brotli-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/eustas/ngx_brotli.git
    MIRROR_HASH:=76b891ba49f82f0cfbc9cba875646e26ee986b522373e0aa2698a9923a4adcdb
    PROTO:=git
  endef
  $(eval $(call Download,nginx-brotli))

  define Prepare/nginx-brotli
	$(eval $(Download/nginx-brotli))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
  endef
endif


ifeq ($(CONFIG_NGINX_RTMP_MODULE),y)
  define Download/nginx-rtmp
    VERSION:=791b6136f02bc9613daf178723ac09f4df5a3bbf
    SUBDIR:=nginx-rtmp
    FILE:=ngx-rtmp-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/arut/nginx-rtmp-module.git
    MIRROR_HASH:=8db3f7b545ce98f47415e0436e12dfb55ae787afd3cd9515b5642c7b9dc0ef00
    PROTO:=git
  endef
  $(eval $(call Download,nginx-rtmp))

  define  Prepare/nginx-rtmp
	$(eval $(Download/nginx-rtmp))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
  endef
endif


ifeq ($(CONFIG_NGINX_TS_MODULE),y)
  define Download/nginx-ts
    VERSION:=ef2f874d95cc75747eb625a292524a702aefb0fd
    SUBDIR:=nginx-ts
    FILE:=ngx-ts-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/arut/nginx-ts-module.git
    MIRROR_HASH:=31ecc9968b928886b54884138eafe2fa747648bca5094d4c3132e8ae9509d1d3
    PROTO:=git
  endef
  $(eval $(call Download,nginx-ts))

  define  Prepare/nginx-ts
	$(eval $(Download/nginx-ts))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
  endef
endif


ifeq ($(CONFIG_NGINX_NAXSI),y)
  define Download/nginx-naxsi
    VERSION:=951123ad456bdf5ac94e8d8819342fe3d49bc002
    SUBDIR:=nginx-naxsi
    FILE:=nginx-naxsi-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/nbs-system/naxsi.git
    MIRROR_HASH:=7ab791f2ff38096f48013141bbfe20ba213d5e04dcac08ca82e0cac07d5c30f0
    PROTO:=git
  endef
  $(eval $(call Download,nginx-naxsi))

  define Prepare/nginx-naxsi
	$(eval $(Download/nginx-naxsi))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
  endef
endif


ifeq ($(CONFIG_NGINX_LUA),y)
  define Download/lua-nginx
    VERSION:=e94f2e5d64daa45ff396e262d8dab8e56f5f10e0
    SUBDIR:=lua-nginx
    FILE:=lua-nginx-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/openresty/lua-nginx-module.git
    MIRROR_HASH:=ae439f9a8b3c34d7240735b844db72ee721af4791bbaff5692bca20e6785f541
    PROTO:=git
  endef
  $(eval $(call Download,lua-nginx))

  define Prepare/lua-nginx
	$(eval $(Download/lua-nginx))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
	$(call PatchDir,$(PKG_BUILD_DIR),./patches-lua-nginx)
  endef
endif


ifeq ($(CONFIG_NGINX_DAV),y)
  define Download/nginx-dav-ext-module
    VERSION:=430fd774fe838a04f1a5defbf1dd571d42300cf9
    SUBDIR:=nginx-dav-ext-module
    FILE:=nginx-dav-ext-module-$(PKG_VERSION)-$$(VERSION).tar.gz
    URL:=https://github.com/arut/nginx-dav-ext-module.git
    MIRROR_HASH:=0566053a8756423ecab455fd9d218cec1e017598fcbb3d6415a06f816851611e
    PROTO:=git
  endef
  $(eval $(call Download,nginx-dav-ext-module))

  define Prepare/nginx-dav-ext-module
	$(eval $(Download/nginx-dav-ext-module))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
  endef
endif

$(eval $(call BuildPackage,nginx))
$(eval $(call BuildPackage,nginx-ssl))
$(eval $(call BuildPackage,nginx-all-module))
$(eval $(call BuildPackage,nginx-mod-luci))
$(eval $(call BuildPackage,nginx-mod-luci-ssl))
