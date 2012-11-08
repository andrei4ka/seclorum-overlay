# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="office suite"
HOMEPAGE="http://www.softmaker.de/"
SRC_URI="${P}.gz"

LICENSE="shareware"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""
RDEPEND=""
progs=" planmaker presentations textmaker"
src_unpack() {
	unpack ${A}
	tar -xf ./${P}; mkdir ${PN}; tar -xzf office.tgz -C ${PN}/
}
src_install() {
	insinto /opt/${PN}
	doins -r ${PN}/*

	for prog in $progs; do
		fperms +x /opt/${PN}/${prog}
	done

	dosym /opt/${PN}/icons/tml_32.png /usr/share/pixmaps/textmaker.png
	dosym /opt/${PN}/icons/pml_32.png /usr/share/pixmaps/planmaker.png
	dosym /opt/${PN}/icons/prl_32.png /usr/share/pixmaps/presentations.png

	make_desktop_entry "/opt/${PN}/textmaker" TextMaker textmaker.png "Office"
	make_desktop_entry "/opt/${PN}/planmaker" PlanMaker planmaker.png "Office"
	make_desktop_entry "/opt/${PN}/presentations" Presentations presentations.png "Office"


}

pkg_postinst() {
	einfo "Obtain a serial number from:"
	einfo "http://www.softmaker.de/oflbetareg.htm"
}
