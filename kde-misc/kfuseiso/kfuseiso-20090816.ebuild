# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2
inherit cmake-utils kde4-base

DESCRIPTION="Small set of modules to help access ISO image files. Along with .iso images also support windows-born .nrg, .mdf, .bin and .img (CloneCD) images "
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=46526"
SRC_URI="http://kde-apps.org/CONTENT/content-files/110509-kfuseiso-20090816.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="nomirror"
IUSE=""

DEPEND="sys-fs/fuseiso"
RDEPEND=""

S="${WORKDIR}/kfuseiso-20090816"

src_configure() {
                cmake-utils_src_configure
}
