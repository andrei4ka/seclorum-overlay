# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Addons WINE"
HOMEPAGE="http://gentoo-wiki.com/TIP_Script_to_unmount_Busy_Devices"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="|| ( app-emulation/wine app-emulation/wine-etersoft-public )"
RDEPEND="${DEPEND}"

src_install() {
    dobin ${FILESDIR}/${PN}
} 
