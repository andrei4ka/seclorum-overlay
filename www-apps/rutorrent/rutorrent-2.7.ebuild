# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit webapp depend.php

DESCRIPTION="Front-end for the popular Bittorrent client rTorrent."
HOMEPAGE="http://code.google.com/p/rutorrent/"
SRC_URI="http://rutorrent.googlecode.com/files/${P/ru/r}.tar.gz -> ${P}.tar.gz
	 http://rutorrent.googlecode.com/files/autotools-1.3.tar.gz -> rutorrent_plugin_autotools-1.3.tar.gz
	 http://rutorrent.googlecode.com/files/choose-1.0.tar.gz -> rutorrent_plugin_choose-1.0.tar.gz
	 http://rutorrent.googlecode.com/files/cookies-1.2.tar.gz -> rutorrent_plugin_cookies-1.2.tar.gz
	 http://rutorrent.googlecode.com/files/create-1.1.tar.gz -> rutorrent_plugin_create-1.1.tar.gz
	 http://rutorrent.googlecode.com/files/darkpal-1.0.tar.gz -> rutorrent_plugin_darkpal-1.0.tar.gz
	 http://rutorrent.googlecode.com/files/datadir-1.0.tar.gz -> rutorrent_plugin_datadir-1.0.tar.gz
	 http://rutorrent.googlecode.com/files/edit-1.2.tar.gz -> rutorrent_plugin_edit-1.2.tar.gz
	 http://rutorrent.googlecode.com/files/erasedata-1.0.tar.gz -> rutorrent_plugin_erasedata-1.0.tar.gz
	 http://rutorrent.googlecode.com/files/geoip-1.1.tar.gz -> rutorrent_plugin_geoip-1.1.tar.gz
	 http://rutorrent.googlecode.com/files/retrackers-1.2.tar.gz -> rutorrent_plugin_retrackers-1.2.tar.gz
	 http://rutorrent.googlecode.com/files/rpc-1.0.tar.gz -> rutorrent_plugin_rpc-1.0.tar.gz
	 http://rutorrent.googlecode.com/files/rss-1.4.tar.gz -> rutorrent_plugin_rss-1.4.tar.gz
	 http://rutorrent.googlecode.com/files/scheduler-1.1.tar.gz -> rutorrent_plugin_scheduler-1.1.tar.gz
	 http://rutorrent.googlecode.com/files/search-1.2.tar.gz -> rutorrent_plugin_search-1.2.tar.gz
	 http://rutorrent.googlecode.com/files/throttle-1.2.tar.gz -> rutorrent_plugin_throttle-1.2.tar.gz
	 http://rutorrent.googlecode.com/files/tracklabels-1.1.tar.gz -> rutorrent_plugin_tracklabels-1.1.tar.gz
	 http://rutorrent.googlecode.com/files/trafic-1.3.tar.gz -> rutorrent_plugin_trafic-1.3.tar.gz
"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

PLUGINS="autotools choose cookies create darkpal datadir edit erasedata geoip retrackers rpc rss scheduler search throttle tracklabels trafic"
IUSE="${PLUGINS}"
RDEPEND="virtual/php
	net-p2p/rtorrent[xmlrpc]"

need_php_httpd

S=${WORKDIR}/${PN/ru/r}

pkg_setup() {
	has_php
	require_php_with_use xmlrpc || die "Re-install ${PHP_PKG} with ${diemsg}"
	webapp_pkg_setup
}

src_unpack(){
	unpack ${A}
	for PLUGIN in ${PLUGINS}; do
		if ! use ${PLUGIN/+/}; then
			rm -Rf ${WORKDIR}/${PLUGIN/+/}
		else
			mv ${WORKDIR}/${PLUGIN/+/} ${S}/plugins
		fi
	done
}


src_install() {
	webapp_src_preinst

	# install htdocs
	cp -R . "${D}"/${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/settings.php
	for a in $(find .  -name settings.php); do
		webapp_serverowned ${MY_HTDOCSDIR}/${a};
	done
	for b in $(find {settings,torrents} -type d); do
		webapp_serverowned ${MY_HTDOCSDIR}/${b};
	done

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
}
