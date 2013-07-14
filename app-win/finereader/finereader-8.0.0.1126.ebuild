# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
EAPI=3

DESCRIPTION="Scan and recognize images"
HOMEPAGE="http://www.finereader.com/"
SRC_URI="ftp://seclorum.ru/etc/gentoo/portage/distfiles/win_${P}.tar.xz"
LICENSE="proprietary"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"

S=${WORKDIR}

INSTALL_PATH="/opt/winsoft"
WIN_DIR_NAME="FineReader"

src_install() {
	dodir ${INSTALL_PATH}
	insinto ${INSTALL_PATH}
	doins -r ${S}/${WIN_DIR_NAME}
	insinto /usr/share/applications
	doins ${WIN_DIR_NAME}/${PN}.desktop || die
}

