# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_P="${PN}-$(get_version_component_range 1-2)-u$(get_version_component_range 3)-b$(get_version_component_range 4)"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Unix port of Monkey's Audio"
HOMEPAGE="http://supermmx.org/linux/mac/"
SRC_URI="http://supermmx.org/resources/linux/mac/${MY_P}.tar.gz"

RESTRICT="mirror"
LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="asmb +shntool"

DEPEND="virtual/libc
	asmb? ( dev-lang/yasm )
	shntool? ( media-sound/shntool )"

src_unpack() {
	unpack "${MY_P}.tar.gz"
	
	epatch ${FILESDIR}/gcc4_errors.patch
	if use shntool; then
		epatch "${FILESDIR}"/mac-3.99-u4-b5-shntool.patch
	fi
}


src_compile() {
	econf $(use_enable asmb assembly) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS INSTALL NEWS README TODO COPYING 
	dohtml ${S}/src/License.htm	${S}/src/Readme.htm
}

