# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp eutils


S=${WORKDIR}/"glpi"

DESCRIPTION="GLPI is the Information Resource-Manager with an additional Administration- Interface. You can use it to build up a database with an inventory for your company (computer, software, printers...)."
HOMEPAGE="http://glpi-project.org/"
SRC_URI="http://www.glpi-project.org/IMG/gz/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="${DEPEND}
 		app-admin/webapp-config" 
RDEPEND="${DEPEND} 
		 virtual/php
		 dev-db/mysql"

src_unpack() {
	cd ${WORKDIR}
	unpack ${A}
}

src_compile() {
	echo "Nothing to compile"
}

src_install() {
	
	webapp_src_preinst

	einfo "Copying main files"
	cd ${S}
	cp -r . ${D}/${MY_HTDOCSDIR} || die

	#All files must be owned by server
	for i in $(find . -print) ; do
		webapp_serverowned ${MY_HTDOCSDIR}/$i || die
	done

#	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-0.7.1.txt
	webapp_src_install

}

