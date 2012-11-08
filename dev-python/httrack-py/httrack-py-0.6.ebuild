# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils


DESCRIPTION="httrack-py library: wrapper to use httrack website copier"
HOMEPAGE="http://code.google.com/p/httrack-py/"
SRC_URI="http://cheeseshop.python.org/packages/source/h/httrack-py/${P}.tar.gz"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "tests failed"
}

