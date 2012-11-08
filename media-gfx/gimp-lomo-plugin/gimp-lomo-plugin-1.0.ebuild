# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Make photos clear, sharp and crisp. Especially useful for outdoor photographs."
HOMEPAGE="http://inphotos.org/gimp-lomo-plugin/"
SRC_URI="http://inphotos.org/wp-content/uploads/2007/10/gimplomo.scm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=media-gfx/gimp-2.4*"
DEPEND="${RDEPEND}"

src_unpack() {
    echo "Nothing unpack"
}

src_compile() {
    echo "Nothing compile"
}

src_install() {
    cp gimplomo.scm /usr/share/gimp/2.0/scripts
}
