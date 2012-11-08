# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="GreAdmin"
HOMEPAGE="http://greece-tours.ru/"
SRC_URI="ftp://seclorum.ru/etc/gentoo/portage/distfiles/win_${P}.tar.bz2"
LICENSE="proprietary"

SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"

S=${WORKDIR}

INSTALL_PATH="/opt/winsoft"
WIN_DIR_NAME="GreAdmin"

src_install() {
	dodir ${INSTALL_PATH}
	insinto ${INSTALL_PATH}
	doins -r ${S}/${WIN_DIR_NAME}
	insinto /usr/share/applications
	doins ${WIN_DIR_NAME}/${PN}.desktop
}

