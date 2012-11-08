# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils rpm gnome2-utils

MY_PV=${PV}-1
DESCRIPTION="Icon theme from Fedora Core 8."
HOMEPAGE="http://fedoraproject.org"
SRC_URI="http://download.fedora.redhat.com/pub/fedora/linux/releases/8/Fedora/source/SRPMS/fedora-icon-theme-${MY_PV}.fc8.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RESTRICT="binchecks strip"

RDEPEND=">=x11-misc/icon-naming-utils-0.8.2
	>=x11-themes/hicolor-icon-theme-0.9"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.33
	sys-devel/gettext"

src_compile() {
	econf
	emake || die "emake failed."
}

src_install() {
	addwrite "/root/.gnome2"

	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
