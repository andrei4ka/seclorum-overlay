# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp depend.php depend.apache

DESCRIPTION="Customer Relationship Management built over LAMP"
HOMEPAGE="http://www.vtiger.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="SPL-1.1.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/httpd-cgi
		>=virtual/mysql-5.0"

need_php_httpd
want_apache

S="${WORKDIR}/${PN}"

src_install () {
	webapp_src_preinst

	cp -R . "${D}"/${MY_HTDOCSDIR}
	cp -R ../data ../modules ../include "${D}"/${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/config.inc.php

		
	for foo in config.inc.php cache cache/import cache/images cache/upload \
	storage install install.php tabdata.php parent_tabdata.php user_privileges \
	Smarty/cache Smarty/templates_c modules/Emails/templates \
	test/wordtemplatedownload test/product test/user test/contact test/logo \
	logs modules/Webmails/tmp; do
		webapp_serverowned ${MY_HTDOCSDIR}/${foo}
	done


	webapp_src_install
}

