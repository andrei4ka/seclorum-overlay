# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="Util to configure Mikrotik OS"
HOMEPAGE="http://mikrotik.com/"
SRC_URI="ftp://seclorum.ru/etc/gentoo/portage/distfiles/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"

S=${WORKDIR}

WIN_DIR_NAME="winbox"
INSTALL_PATH="/opt/winsoft/winbox"


src_install() {
	dodir ${INSTALL_PATH}
	insinto ${INSTALL_PATH}
	doins ${FILESDIR}/${PN}.png
	newins ${P}.exe ${PN}.exe
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop
}