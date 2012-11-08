# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils

DESCRIPTION="GSQL opensource project is to supply database developers with an universal tool platform tailored against market leading DBMS"
HOMEPAGE="http://gsql.org/"
SRC_URI="http://gsql.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""

DEPEND="x11-libs/gtk+:2
	gnome-base/gconf:2
	dev-libs/glib:2
	gnome-base/libglade
	x11-libs/libnotify
	x11-libs/gtksourceview:2.0
	x11-libs/vte"

src_unpack() {
	unpack ${A}
	cd "${S}"
}
src_compile() {
	econf || die "econf failed"
	emake || die "compile problem"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}