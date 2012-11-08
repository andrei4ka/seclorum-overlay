# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils versionator

DESCRIPTION="NetUP UTM - universal billing system for Internet Service Providers."
HOMEPAGE="www.netup.ru"
MY_PN="utm5"
MY_PV="5.${PV}"
SRC_URI="${P}.tar.bz2"

LICENSE="NETUP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql +postgresql web"

RESTRICT="fetch nostrip"

RDEPEND="virtual/libc
	dev-libs/openssl
	sys-libs/zlib
	dev-libs/libxslt
	mysql? ( dev-db/mysql )
	postgresql? ( dev-db/postgresql-server
		      app-admin/eselect-postgresql )
	amd64? ( app-emulation/emul-linux-x86-baselibs )	

"
S=${WORKDIR}

UTM_INSTALL_DIR="/netup/utm5"
UTM_CFG_DIR="/etc/utm5"
UTM_DB_DIR="/var/lib/utm5/db"
UTM_LOG_DIR="/var/log/utm5"
UTM_BACKUP_DIR="/var/lib/utm5/backup"
UTM_PID_FILE="/var/run/safe_utm5_core.pid"
UTM_SQL_DIR="/var/lib/utm5/sql"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "http://www.netup.ru/"
	einfo "and move it to ${DISTDIR}"
}


pkg_setup() {

	for process in utm5_radius utm5_rfw utm5_core
	do
		if `ps aux | grep -v "grep ${process}" | grep ${process} >/dev/null 2>&1` ; then
			ewarn "You did not stop ${process}."
			ewarn "Please stop all process with ${process} in"
			ewarn "their names and then try again."
			die "Processes are not stoped."
		fi
	done
}

src_unpack() {

	unpack ${A}
	cp -r ${FILESDIR}/${MY_PV} ${WORKDIR}
}

src_install() {
	cd ${WORKDIR}

	if use web; then
		cp -a usr ${D} || die "install failed"
	fi

	dodir ${UTM_INSTALL_DIR}
	dodir ${UTM_CFG_DIR}
	dodir ${UTM_DB_DIR}
	dodir ${UTM_BACKUP_DIR}
	dodir ${UTM_SQL_DIR}
	dodir ${UTM_LOG_DIR}
	
	mkdir sql
	mv netup/utm5/*.sql sql
	rm -Rf netup/utm5/db
	rm -Rf netup/utm5/log
	rm -Rf netup/utm5/backup

	insinto ${UTM_SQL_DIR}
	doins sql/*.sql
	cp -a netup ${D}
	dosym ${UTM_DB_DIR} ${UTM_INSTALL_DIR}/db
	dosym ${UTM_BACKUP_DIR} ${UTM_INSTALL_DIR}/backup
	dosym ${UTM_SQL_DIR} ${UTM_INSTALL_DIR}/sql
	dosym ${UTM_LOG_DIR} ${UTM_INSTALL_DIR}/log
 

	
	keepdir ${UTM_BACKUP_DIR}
	keepdir ${UTM_DB_DIR}
	keepdir ${UTM_LOG_DIR}
	keepdir ${UTM_INSTALL_DIR}/templates
	
	sed -i -e "s:/netup/utm5/log:${UTM_LOG_DIR}:" ${WORKDIR}/${MY_PV}/utm5.cfg
	sed -i -e "s:/netup/utm5/log:${UTM_LOG_DIR}:" ${WORKDIR}/${MY_PV}/radius5.cfg
	sed -i -e "s:/netup/utm5/log:${UTM_LOG_DIR}:" ${WORKDIR}/${MY_PV}/rfw5.cfg
	sed -i -e "s:firewall_path=/sbin/ipfw:firewall_path=/sbin/iptables:" ${WORKDIR}/${MY_PV}/rfw5.cfg
	


	for conf in `find ${WORKDIR}/${MY_PV} -maxdepth 1 -type f -name \*.cfg`
		do
			insinto ${UTM_CFG_DIR}
			doins $conf
			dosym ${UTM_CFG_DIR}/`basename $conf` ${UTM_INSTALL_DIR}/`basename $conf`
		done

	doinitd ${WORKDIR}/${MY_PV}/utm5_core ${WORKDIR}/${MY_PV}/utm5_radius ${WORKDIR}/${MY_PV}/utm5_rfw
	newconfd ${WORKDIR}/${MY_PV}/utm5_rfw.conf utm5_rfw
	newconfd ${WORKDIR}/${MY_PV}/utm5_core.conf utm5_core
}

pkg_prerm() {
	if [ -d ${UTM_BACKUP_DIR} ]; then find ${UTM_INSTALL_DIR} -maxdepth 1 -name "*.cfg" -exec cp {} ${UTM_BACKUP_DIR} \;;fi
}

pkg_postinst() {
	echo
		einfo "If this is your first instalation of utm5 please run:"
		einfo "mysqladmin create UTM5"
		einfo "mysql UTM5 < /netup/utm5/sql/UTM5_MYSQL.sql"
		einfo "mysql UTM5 < your_reg_file.sql"
		einfo "to initialise mysql database. Or"
		einfo "createdb -U postgres UTM5"
		einfo "psql UTM5 < /netup/utm5/sql/UTM5_MYSQL.sql"
		einfo "psql UTM5 < your_reg_file.sql"
		einfo "to initialise postgresql database."

		einfo "Now, please, update your database with command"
		einfo "mysql -f UTM5 < /netup/utm5/sql/UTM5_MYSQL_update.sql"
		einfo "if you are using mysql database or"
		einfo "psql -f /netup/utm5/sql/UTM5_PG_update.sql UTM5"
		einfo "if you are using postgresql."
		einfo ""
		einfo "Please note. You need to update your UTM5_Admin.jar also."

	echo
	einfo "To start utm5_core automaticaly during booting you need to run:"
	einfo "rc-update add utm5_core default"
	echo
	ewarn "Note: Configuration files are in /etc/utm5."
	echo
	einfo "Thank you for choosing utm5."
}
