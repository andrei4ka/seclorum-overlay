# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: by Ilya Kashirin (seclorum@gmail.com)
EAPI=4

DESCRIPTION="Remote desktop sharing"
HOMEPAGE="http://ammyy.com/"
SRC_URI="http://www.ammyy.com/AA_v3.1.exe -> ${P}.exe"
LICENSE="GPL-2"

SLOT="3"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"

S=${WORKDIR}

WIN_DIR_NAME=${PN}
INSTALL_PATH="/opt/winsoft/${PN}"

src_unpack(){
	cp ${DISTDIR}/${A} ${WORKDIR}
}

src_install() {
	dodir ${INSTALL_PATH}
	insinto ${INSTALL_PATH}
	doins ${FILESDIR}/${PN}${SLOT}.png
	newins ${P}.exe ${PN}${SLOT}.exe
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}${SLOT}.desktop
}