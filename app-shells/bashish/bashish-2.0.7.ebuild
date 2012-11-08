# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## http://bugs.gentoo.org/show_bug.cgi?id=130107

inherit eutils

DESCRIPTION="Text console theme engine"
HOMEPAGE="http://bashish.sourceforge.net/"
SRC_URI="mirror://sourceforge/bashish/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
DEPEND="dialog? ( >=dev-util/dialog-1.0 )"

src_compile() {
	./configure \
		--with-shell=/bin/bash \
		--prefix=/usr \
		--mandir=/usr/share/man \
		${myflags} || die "Bashish ./configure Failed"
}

src_install() {

	#make \
	#	prefix=${D}/usr \
	#	mandir=${D}/usr/share/man \
	#	install || die "Bashish Make Install Failed"
	make \
		DESTDIR=${D} \
		install || die "Bashish Make Install Failed"
}
