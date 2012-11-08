# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="A scanner button daemon for Linux"
HOMEPAGE="http://scanbuttond.sourceforge.net/"
SRC_URI="mirror://sourceforge/scanbuttond/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libusb-0.1.10a"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
	exeinto /etc/init.d/
	doexe ${FILESDIR}/scanbuttond
}
