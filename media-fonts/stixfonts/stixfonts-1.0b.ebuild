# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
inherit font

DESCRIPTION="STIX Fonts OpenType fonts"
HOMEPAGE="http://www.stixfonts.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="stix"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="otf"
FONT_S="${WORKDIR}/${P}"

# Only installs fonts
RESTRICT="strip binchecks"
