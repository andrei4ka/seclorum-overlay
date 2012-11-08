# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5

inherit distutils eutils

DESCRIPTION="A full-featured, crossplatform, extensible desktop note-taking application"
HOMEPAGE="http://notefinder.co.cc/"
SRC_URI="http://notefinder.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="feed kde"

DEPEND="
	>=dev-lang/python-2.5
	>=dev-python/PyQt4-4.3.3
	>=dev-python/genshi-0.5.1
	>=dev-python/setuptools-0.5
	feed? ( >=dev-python/feedparser-4.1 )
	kde? ( >=dev-python/pykde-3.16 )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	distutils_src_install
}

