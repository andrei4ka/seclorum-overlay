# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Ilya Kashirin (seclorum@seclorum.ru)

inherit eutils

DESCRIPTION="Frontend for Xavier Roche's HTTrack Website Copier"
HOMEPAGE="http://home.hccnet.nl/paul.schuurmans/linux/index.html#ghttrack"
SRC_URI="http://home.hccnet.nl/paul.schuurmans/linux/download/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="www-client/httrack
	>=x11-libs/gtk+-2.4"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-autogen.patch
	sh autogen.sh || die
}


src_install() {
	make DESTDIR="${D}" install || die
	doicon ${FILESDIR}/ghttrack.xpm
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "Network;WebBrowser"
}
