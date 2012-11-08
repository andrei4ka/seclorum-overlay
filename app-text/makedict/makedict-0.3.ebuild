# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"
SRC_URI="http://downloads.sourceforge.net/xdxf/makedict-0.3.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
        econf || die "configure failed"
        emake || die "parallel make failed"
}

src_install() {
        make DESTDIR=${D} install || die "make install failed"
}
