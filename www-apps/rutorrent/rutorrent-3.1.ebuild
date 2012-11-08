# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit webapp depend.php

DESCRIPTION="Front-end for the popular Bittorrent client rTorrent."
HOMEPAGE="http://code.google.com/p/rutorrent/"
SRC_URI="http://rutorrent.googlecode.com/files/${P}.tar.gz
	 http://rutorrent.googlecode.com/files/plugins-${PV}.tar.gz -> rutorrent_plugins-${PV}.tar.gz

"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

PLUGINS="autotools chunks cookies cpuload create darkpal data datadir diskspace edit erasedata geoip httprpc ratio retrackers rpc rss scheduler search seedingtime show_peers_like_wtorrent source throttle tracklabels trafic unpack"


IUSE="${PLUGINS}"
RDEPEND="virtual/php
	net-p2p/rtorrent[xmlrpc]"

need_php_httpd

S=${WORKDIR}/${PN}

pkg_setup() {
	has_php
	require_php_with_use xmlrpc || die "Re-install ${PHP_PKG} with ${diemsg}"
	webapp_pkg_setup
}

src_unpack(){
	unpack ${A}
	for PLUGIN in ${PLUGINS}; do
		if use ${PLUGIN/+/}; then
			mv ${WORKDIR}/plugins/${PLUGIN/+/} ${S}/plugins
		fi
	done
}


src_install() {
	webapp_src_preinst

	# install htdocs
	cp -R . "${D}"/${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/php/settings.php
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
