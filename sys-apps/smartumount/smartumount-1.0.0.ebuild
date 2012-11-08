# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Script to unmount Busy Devices"
HOMEPAGE="http://gentoo-wiki.com/TIP_Script_to_unmount_Busy_Devices"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

src_install() {
    dobin ${FILESDIR}/${PN}
} 
