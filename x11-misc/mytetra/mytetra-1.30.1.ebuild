# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-misc/mytetra/mytetra-1.30.1.ebuild,v 1.0 2012/04/28 23:00:00

EAPI=3
inherit versionator eutils qt4-r2

MY_P=${PN}_$(replace_all_version_separators '_')

DESCRIPTION="Smart manager for information collecting"
HOMEPAGE="http://webhamster.ru/site/page/index/articles/projectcode/"
SRC_URI="http://webhamster.ru/db/data/articles/105/${MY_P}_src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}_src"

src_install() {
	qt4-r2_src_install
	domenu desktop/mytetra.desktop
	doicon desktop/mytetra.png
}

