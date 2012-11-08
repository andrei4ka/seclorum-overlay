# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This is a very simple and most likely inefficient way of getting your total merge time, but until genlop can do it on its own"
HOMEPAGE="http://gentoo-wiki.com/TIP_Getting_total_merge_time"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND="app-portage/genlop
	dev-lang/python"

src_install() {
    dobin ${FILESDIR}/${PN}
}
