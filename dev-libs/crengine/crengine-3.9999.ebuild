# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


#ECVS_TOP_DIR=${DISTDIR}/cvs-src/${PN}

inherit eutils cvs

DESCRIPTION="CoolReader Engine is fast and small cross-platform XML/CSS visualization library for writing E-Book readers for desktops as well as for handheld devices."
HOMEPAGE="http://coolreader.org"
ECVS_SERVER="crengine.cvs.sourceforge.net:/cvsroot/crengine"
ECVS_MODULE="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug static"

DEPEND=""
RDEPEND=""
#RDEPEND=">=x11-libs/wxGTK-2.6.0
#	>=media-libs/freetype-2.0
#	dev-libs/crengine"

S=${WORKDIR}/${ECVS_MODULE}

src_unpack() {
	cvs_src_unpack
	cd ${S}
	./autogen.sh
}

src_compile() {
	econf || die "conf failed"
	local myconf=""
	if use debug; then
		myconf="${myconf} BUILD=Debug"
	else
		myconf="${myconf} BUILD=Release"
	fi
	if use static; then
		myconf="${myconf} SHARED=0"
	else
		myconf="${myconf} SHARED=1"
	fi
	emake ${myconf} || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc readme.txt AUTHORS LICENSE docs/WolfFormat.txt
#	libopts -m0755
#	local lpath="build/linux/i386/Release"
#	local lext="so"
#	if use debug; then
#		lpath="build/linux/i386/Debug"
#	fi
#	if use static; then
#		lext="a"
#	fi
#	dolib ${lpath}/libcrengine.${lext}
	dodir /usr/include/${PN}
	insinto /usr/include/${PN}
	doins include/*
}
