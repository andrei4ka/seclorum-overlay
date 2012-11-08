# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools cvs

ECVS_SERVER="${PN}.cvs.sourceforge.net:/cvsroot/${PN}"
ECVS_MODULE="${PN}"

DESCRIPTION="Scanner button daemon for Linux"
HOMEPAGE="http://scanbuttond.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libusb-0.1.10a"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	eautoreconf || die "eautoreconf failed"
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	exeinto /etc/init.d/
	doexe ${FILESDIR}/scanbuttond
	dodoc AUTHORS BUGS ChangeLog README
}
