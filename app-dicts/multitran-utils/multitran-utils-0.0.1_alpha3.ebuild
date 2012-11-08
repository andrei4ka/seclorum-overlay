# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_P=${P/_}
MY_P1=${MY_P/multitran/mt}

DESCRIPTION="Multitran simple command line utilities for dictionary maintainance"
HOMEPAGE="http://multitran.sourceforge.net/"
SRC_URI="mirror://sourceforge/multitran/${MY_P1}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="app-dicts/multitran-libmtsupport
	app-dicts/multitran-libbtree
	app-dicts/multitran-libfacet
	app-dicts/multitran-libmtquery"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P1}

src_compile() {
	cd ${S}
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install

#	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
