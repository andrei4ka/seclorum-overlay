# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="FBReader Tango Icons theme"
HOMEPAGE="http://seclorum.ru"
SRC_URI="ftp://seclorum.ru/etc/gentoo/portage/distfiles/${P}.tar.bz2"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="app-text/fbreader"

S=${WORKDIR}/${PN}

src_install() {
	rm -Rf /usr/share/pixmaps/FBReader/*
	insinto /usr/share/pixmaps/FBReader
	doins ${S}/*
}

