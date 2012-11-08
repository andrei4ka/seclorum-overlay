# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The Human Cursor theme"
HOMEPAGE="https://launchpad.net/products/human-cursors-theme"
SRC_URI="http://librarian.launchpad.net/4886280/${PN}_${PV}.orig.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	einstall || die "einstall failed"
}
