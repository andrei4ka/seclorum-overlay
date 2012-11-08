# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gqview/gqview-2.1.5.ebuild,v 1.1 2006/12/10 09:02:36 mr_bones_ Exp $

DESCRIPTION="A GTK-based image browser"
HOMEPAGE="http://geeqie.sourceforge.net/"
MY_PV="1.0alpha1"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://sourceforge/geeqie/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="lcms exiv2"

RDEPEND=">=x11-libs/gtk+-2.4.0
	exiv2? ( media-gfx/exiv2 )
	lcms? ( media-libs/lcms )
	virtual/libintl"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"
S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_with lcms) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	# leave README uncompressed because the program reads it
	dodoc AUTHORS ChangeLog TODO
	rm -f "${D}/usr/share/doc/${PF}/COPYING"
}
