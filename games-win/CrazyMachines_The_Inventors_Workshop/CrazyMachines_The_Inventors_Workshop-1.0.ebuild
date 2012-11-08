# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="Logic Game - Crazy Machines: Family Fun"
HOMEPAGE="http://www.prema.ru/"
SRC_URI="ftp://seclorum.ru/etc/gentoo/portage/distfiles/wingames_${PN}.tar.bz2"
LICENSE="proprietary"

SLOT="0"
KEYWORDS="x86"
IUSE="solution"

DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"

S=${WORKDIR}

INSTALL_PATH="/opt/wingames"
WIN_DIR_NAME="${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	if ! use solution; then
	      rm -f "${WORKDIR}/${WIN_DIR_NAME}/*pdf" || die
	fi
}
src_install() {
	dodir ${INSTALL_PATH}
	insinto ${INSTALL_PATH}
	doins -r ${S}/${WIN_DIR_NAME}
	insinto /usr/share/applications
	doins ${WIN_DIR_NAME}/${PN}.desktop
	fperms 660 ${INSTALL_PATH}/${WIN_DIR_NAME}/scripts/config/{3dinit,config,labs,sysinit}.vsc
	fperms 660 ${INSTALL_PATH}/${WIN_DIR_NAME}/data/labs/{Лаборатория\ Профессора,Моя\ лаборатория}.cml
	fperms 660 ${INSTALL_PATH}/${WIN_DIR_NAME}/CrazyMachines.log
	fowners -R games:games ${INSTALL_PATH}/${WIN_DIR_NAME}/
}