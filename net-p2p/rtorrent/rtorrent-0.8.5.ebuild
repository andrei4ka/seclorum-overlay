# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.5.ebuild,v 1.1 2009/09/10 17:56:41 patrick Exp $

inherit base eutils toolchain-funcs flag-o-matic

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="daemon debug ipv6 xmlrpc fakename"

COMMON_DEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2.2.2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	fakename? ( >=net-libs/libtorrent-0.12.5[fakename] )
	"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

FAKE_NAME="1830"
src_unpack(){
	unpack ${A}
	cd ${S}
	if use fakename; then
	    sed -i -e "s:#define USER_AGENT std\:\:string(PACKAGE \"/\" VERSION \"/\") + torrent\:\:version():#define USER_AGENT \"uTorrent/${FAKE_NAME}\":g" configure
	fi
}

src_compile() {
	replace-flags -Os -O2
	append-flags -fno-strict-aliasing

	if [[ $(tc-arch) = "x86" ]]; then
		filter-flags -fomit-frame-pointer -fforce-addr
	fi

	econf	$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c) \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO doc/rtorrent.rc

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd || die "newinitd failed"
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd || die "newconfd failed"
	fi
}

pkg_postinst() {
	elog "rtorrent now supports a configuration file."
	elog "A sample configuration file for rtorrent can be found"
	elog "in rtorrent.rc in ${ROOT}usr/share/doc/${PF}/"
	elog ""
	ewarn "If you're upgrading from rtorrent <0.8.0, you will have to delete your"
	ewarn "session directory or run the fixSession080-c.py script from this address:"
	ewarn "http://rssdler.googlecode.com/files/fixSession080-c.py"
	ewarn "See http://libtorrent.rakshasa.no/wiki/LibTorrentKnownIssues for more info."
}
