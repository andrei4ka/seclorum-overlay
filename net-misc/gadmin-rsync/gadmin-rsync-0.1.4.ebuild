# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit pam

DESCRIPTION="GTK frontend for the rsync backup client and server"
HOMEPAGE="http://mange.dynalias.org/linux.html"
SRC_URI="http://mange.dynalias.org/linux/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome"

DEPEND=">=x11-libs/gtk+-2.0"
RDEPEND="${DEPEND}
	net-misc/rsync"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "einstall failed"

	if use gnome; then
		insinto /usr/share/gnome/apps/
		doins ${S}/desktop/${PN}.desktop
	fi

	dodoc AUTHORS ChangeLog INSTALL README

	dopamd ${S}/etc/pam.d/${PN}
	dopamsecurity console.apps ${S}/etc/security/console.apps/${PN}
}
