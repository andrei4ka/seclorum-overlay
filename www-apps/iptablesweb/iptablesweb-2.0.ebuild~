# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp depend.php

DESCRIPTION="Web application to monitor iptables logs via web browser and e-mail"
SRC_URI="http://dev.gentooexperimental.org/~jakub/distfiles/${P}.tar.gz"
HOMEPAGE="http://www.iptablesweb.com/"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="app-admin/ulogd
	net-firewall/iptables
	virtual/cron
	virtual/httpd-cgi"

need_php_httpd

S="${WORKDIR}/${PN}"

pkg_setup() {
	local flags="mysql postgres oci8 sqlite"
	if ! PHPCHECKNODIE="yes" require_php_with_any_use ${flags} \
		|| ! PHPCHECKNODIE="yes" require_php_with_any_use gd gd-external ; then
			die "Re-install ${PHP_PKG} with at least one of ${flags} and either gd or gd-external in USE."
	fi
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst
	local files="includes/session_settings.php includes/connection_settings.php includes/path_settings.php"

	dodoc docs/ChangeLog.txt docs/en/install.txt

	cp -r . "${D}/${MY_HTDOCSDIR}"
	rm -rf "${D}/${MY_HTDOCSDIR}/docs"

	for file in ${files}; do
		webapp_serverowned "${MY_HTDOCSDIR}/${file}"
	done

	keepdir "${MY_HTDOCSDIR}/tmp"

	webapp_configfile "${MY_HTDOCSDIR}/includes/config.php"
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
