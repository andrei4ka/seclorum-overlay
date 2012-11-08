# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

DESCRIPTION="Addons WINE"
HOMEPAGE="http://www.kegel.com/wine/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
SRC_URI="http://www.kegel.com/wine/winetricks -> ${P}"
DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"
RDEPEND="${DEPEND}"


src_install() {
    newbin ${DISTDIR}/${P} ${PN}
} 
