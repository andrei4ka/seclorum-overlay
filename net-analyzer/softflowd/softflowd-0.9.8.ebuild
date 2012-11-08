# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Softflowd is flow-based network traffic analyser capable of Cisco NetFlow data export."
HOMEPAGE="http://www.mindrot.org/softflowd.html"
SRC_URI="http://www2.mindrot.org/files/softflowd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	# TODO:
	# report to upstream
	# epatch ${FILESDIR}/${P}-destdir.patch
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README ChangeLog TODO
}
