# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="init.d script to autodetect and activate swap partition"
HOMEPAGE="http://gentoo-wiki.com/TIP_automount_swap"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_install() {
	doinitd ${FILESDIR}/${PN}
} 

pkg_postinst() {
	einfo "To activate autoswap run \"rc-update add autoswap boot\""
	einfo "Next you can comment swap in /etc/fstab"
}