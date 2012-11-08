# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit kde

DESCRIPTION="KWin window decoration for KDE 3.2 that mimics Gnome's clearlooks"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=${KLV}"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( kde-base/kwin kde-base/kdebase )"
RDEPEND="${DEPEND}"

need-kde 3.2

src_compile() {
	echo "Nothing compile"
}

src_install() {
	cp -R ${S}/*.jpg ${KDEDIR}/share/wallpapers
}
