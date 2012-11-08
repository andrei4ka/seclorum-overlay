# Copyright 2007-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Metromap is simple pygtk+2 programm for finding paths in metro(subway) maps."
HOMEPAGE="http://metromap.antex.ru/"
SRC_URI="http://metromap.antex.ru/${P}.tar.bz2"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 "

DEPEND=">=dev-python/pygtk-2.10
	x11-libs/cairo"

RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}"/usr install || die "emake install failed!"
	
}