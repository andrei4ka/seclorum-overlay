# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Data files for the English-Russian-English Multitran dictionary"
HOMEPAGE="http://www.multitran.ru"
SRC_URI="mirror://sourceforge/multitran/multitran-data.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="app-dicts/multitran"

S=${WORKDIR}/${PN}

src_install() {
	cd ${S}
	make DESTDIR="${D}" install

}

