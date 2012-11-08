# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Author: Valery Novikov (devel0per) $

inherit eutils 

DESCRIPTION="This is Gentoo packages automatic unmasker"
HOMEPAGE="http://devel0per-soft.blogspot.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="GPL2"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="sys-apps/portage
		app-portage/eix"

RDEPEND="${DEPEND}"

src_install()
{
	dobin usr/bin/unmasker
	cp -rf ${S}/etc ${D}
}

pkg_postinst()
{
	cat $S/README
}

