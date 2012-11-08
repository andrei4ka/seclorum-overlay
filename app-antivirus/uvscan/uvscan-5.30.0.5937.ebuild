# Copyright 1999-2009eb Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
#

inherit eutils versionator

DESCRIPTION="Mcafee commaind line virus-scanner"

HOMEPAGE="http://www.nai.com/"

SRC_URI="${P}.tar.bz2"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86"
LICENSE="Mcafee"
SLOT="0"

RESTRICT="primaryurl"

RDEPEND=""

DEPEND="${RDEPEND}"

INSTALLDIR="/opt/${PN}"
S="${WORKDIR}"

src_unpack () {
	unpack ${A}
	cd ${S}
}

src_compile() {
  echo "nothing compile"
}

src_install() {
	dodir ${INSTALLDIR}/
	cp ${S}/* "${D}/${INSTALLDIR}/" || die "Install failed!"
	dosym ${INSTALLDIR}/${PN} /usr/bin/${PN}
	
	doman uvscan.1	
}
