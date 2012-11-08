# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="SIM Tango Icons theme"
HOMEPAGE="http://sim-im.org"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/101747-SIM_Tango_Pack_0.0.3.zip"
LICENSE="Creative Commons Attribution-Share Alike"

SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="net-im/sim"

S=${WORKDIR}

src_install() {
	insinto /usr/share/apps/sim/icons
	doins ${S}/*.jisp
	insinto /usr/share/apps/sim/styles
	doins *.xsl
}

