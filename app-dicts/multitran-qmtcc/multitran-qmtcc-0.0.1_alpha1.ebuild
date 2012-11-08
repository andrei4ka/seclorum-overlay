# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm versionator

MY_P=${P/_}
MY_P1=${MY_P/multitran-}
DESCRIPTION="Qt-based graphical frontend for Multitran dictionary"
HOMEPAGE="http://multitran.sourceforge.net/"
SRC_URI="ftp://ftp.altlinux.ru/pub/distributions/ALTLinux/Sisyphus/files/SRPMS/qmtcc-0.0.1-alt3.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="app-dicts/multitran-libmtsupport
	app-dicts/multitran-libbtree
	app-dicts/multitran-libfacet
	app-dicts/multitran-libmtquery
	=x11-libs/qt-3*"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P1}

src_unpack () {
	rpm_src_unpack ${A}
}

src_compile() {
	cd ${S}
	sed -i -e "s:/usr/lib/qt3/mkspecs/default/qmake.conf:/usr/qt/3/mkspecs/linux-g++/qmake.conf:g" Makefile
	sed -i -e "s:/usr/lib/qt3/mkspecs/default/qmake.conf:/usr/qt/3/mkspecs/linux-g++/qmake.conf:g" src/Makefile
	sed -i -e "s:-pipe -Wall -W -pipe -Wall -O2 -march=i586 -mcpu=i686:${CFLAGS}:g" src/Makefile
	emake || die "emake failed"
}

src_install() {
	dobin "${S}"/src/qmtcc
}
