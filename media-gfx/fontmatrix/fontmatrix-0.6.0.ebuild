# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cmake-utils qt4

DESCRIPTION="A font manager"
HOMEPAGE="http://www.fontmatrix.net/"
SRC_URI="http://www.fontmatrix.net/archives/${PN}-${PV}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="debug"

DEPEND="
	>=media-libs/freetype-2"

S="${WORKDIR}/${P}-Source"
B="${S}_build"

src_compile() {
	local mycmakeargs="-DOWN_SHAPER=1"
	cmake-utils_src_compile
	cd ${B}
	emake || die "emake failed"
}

src_install() {
#	exeinto /usr/bin
#	doexe ${B}/src/${PN}
#	emake DESTDIR="${D}" install || die "Install failed"
#	newicon ${PN}.png ${PN}.png
#	make_desktop_entry ${PN} "Fontmatrix" ${PN}.png "Graphics"
	cmake-utils_src_install
}

pkg_postinst() {
	einfo "If you encounter problems or just have questions or if you have"
	einfo " suggestions, please take time to suscribe to the undertype-users"
	einfo " mailing list ( https://mail.gna.org/listinfo/undertype-users )."
	einfo " If you want to reach us quickly, come to #fontmatrix at Freenode."
}
