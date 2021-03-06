# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp

DESCRIPTION="The Ajax CMS for today. And tomorrow"
HOMEPAGE="http://modxcms.com/"
SRC_URI="http://modxcms.com/download/ga/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/httpd-cgi
	>=virtual/mysql-4.1
	|| ( dev-lang/php[mysql] dev-lang/php[mysqli] )"

src_install() {
	webapp_src_preinst
	find -name ht.access -exec sh -c \
		'f="{}"; mv "${f}" "${f%ht.access}.htaccess"' \; \
		|| die "Dot fix failed"
	insinto ${MY_HTDOCSDIR}
	doins -r . || die "Instalation failed"
	webapp_src_install
}
