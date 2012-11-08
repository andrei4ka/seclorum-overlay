# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic multilib

DESCRIPTION="MS Windows compatibility layer (WINE@Etersoft public edition)"
HOMEPAGE="http://etersoft.ru/wine"


SRC_URI="${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="!app-emulation/wine"

DEPEND="${RDEPEND}
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	sys-devel/bison
	sys-devel/flex"

src_install() {
	echo ${S}
	cp -R ${S}/* "${D}" || die "Install failed!"
}

pkg_postinst() {
	elog "~/.wine/config is now deprecated.  For configuration either use"
	elog "winecfg or regedit HKCU\\Software\\Wine"
}
