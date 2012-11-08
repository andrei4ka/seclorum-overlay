# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Script to control init.d services"
HOMEPAGE="http://seclorum.ru"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

src_install() {
	dobin ${FILESDIR}/${PN}
} 
