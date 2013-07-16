# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ by Ilya Kashirin (seclorum@gmail.com)
EAPI=5

DESCRIPTION="Russian support UTF in console"
HOMEPAGE="http://gentoo-wiki.com/TIP_Script_to_unmount_Busy_Devices"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
S=${WORKDIR}

src_unpack() {
    echo "Nothing unpack"
}

src_install() {
    cp ${FILESDIR}/${PN}.map.gz ${WORKDIR}
    insinto /usr/share/keymaps/i386/qwerty
    doins ${PN}.map.gz
}
