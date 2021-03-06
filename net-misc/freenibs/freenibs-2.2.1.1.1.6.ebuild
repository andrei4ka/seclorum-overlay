# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
WANT_AUTOMAKE="none"

inherit eutils multilib autotools versionator

FN_PV="$(get_version_component_range 1-3)"
FR_PV="$(get_version_component_range 4-)"

DESCRIPTION="FreeNIBS is a loadable module for FreeRADIUS radius-server. It provide authorization, authentication and accounting mechanism for Dialin (PPP/PPPOE/PPTP) users."

SRC_URI="http://switch.dl.sourceforge.net/sourceforge/freesnibs/freenibs-${FN_PV}.tar.bz2
	 ftp://ftp.freeradius.org/pub/radius/freeradius-${FR_PV}.tar.gz"

HOMEPAGE="http://stasoft.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

IUSE="debug edirectory firebird frascend frnothreads frxp kerberos ldap mysql pam postgres snmp ssl udpfromto"

RDEPEND="!net-dialup/cistronradius
	!net-dialup/gnuradius
	>=sys-libs/db-3.2
	sys-libs/gdbm
	dev-lang/perl
	snmp? ( net-analyzer/net-snmp )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	firebird? ( dev-db/firebird )
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	kerberos? ( virtual/krb5 )
	frxp? ( dev-lang/python )"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

S=${WORKDIR}/freeradius-${FR_PV}
src_unpack() {
	unpack freeradius-${FR_PV}.tar.gz
	unpack freenibs-${FN_PV}.tar.bz2
	cp -Rf ${WORKDIR}/freenibs-${FN_PV}/* ${WORKDIR}/freeradius-${FR_PV}/
	sed -i -e 's/1140/1160/g' ${WORKDIR}/freeradius-${FR_PV}/src/modules/rlm_nibs/conf.h

	epatch "${FILESDIR}/freenibs_host_mysql_fix.patch"
	epatch "${FILESDIR}/freenibs_host_fix.patch"
	epatch "${FILESDIR}/freeradius-${FR_PV}-versionless-la-files.patch"
	epatch "${FILESDIR}/freeradius-${FR_PV}-ssl.patch"
	epatch "${FILESDIR}/freeradius-${FR_PV}-qa-fixes.patch"

	cd "${S}"

	# kill modules we don't use
	if ! use ssl; then
		einfo "removing rlm_eap_tls and rlm_x99_token (no use ssl)"
		rm -rf src/modules/rlm_eap/types/rlm_eap_tls src/modules/rlm_x99_token
	fi
	if ! use ldap; then
		einfo "removing rlm_ldap (no use ldap)"
		rm -rf src/modules/rlm_ldap
	fi
	if ! use kerberos; then
		einfo "removing rlm_krb5 (no use kerberos)"
		rm -rf src/modules/rlm_krb5
	fi
	if ! use pam; then
		einfo "removing rlm_pam (no use pam)"
		rm -rf src/modules/rlm_pam
	fi
	if ! use mysql; then
		einfo "removing rlm_sql_mysql (no use mysql)"
		rm -rf src/modules/rlm_sql/drivers/rlm_sql_mysql
		sed -i -e '/rlm_sql_mysql/d' src/modules/rlm_sql/stable
	fi
	if ! use postgres; then
		einfo "removing rlm_sql_postgresql (no use postgres)"
		rm -rf src/modules/rlm_sql/drivers/rlm_sql_postgresql
		sed -i -e '/rlm_sql_postgresql/d' src/modules/rlm_sql/stable
	fi
	if ! use firebird; then
		einfo "removing rlm_sql_firebird (no use firebird)"
		rm -rf src/modules/rlm_sql/drivers/rlm_sql_firebird
		sed -i -e '/rlm_sql_firebird/d' src/modules/rlm_sql/stable
	fi

	eautoconf || die "eautoconf failed"
}

src_compile() {
	local myconf=" \
		$(use_enable debug developer) \
		$(use_with snmp) \
		$(use_with frascend ascend-binary) \
		$(use_with frxp experimental-modules) \
		$(use_with udpfromto) \
		$(use_with edirectory edir) "

	if useq frnothreads; then
		myconf="${myconf} --without-threads"
	fi

	#fix bug #77613
	if has_version app-crypt/heimdal; then
		myconf="${myconf} --enable-heimdal-krb5"
	fi

	econf --with-large-files --disable-ltdl-install --with-pic \
		 --localstatedir=/var ${myconf} || die "econf failed"

	make || die "make failed"
}

src_install() {
	dodir /etc
	dodir /var/log
	dodir /var/run
	diropts -m0750 -o root -g radiusd
	dodir /etc/raddb
	diropts -m0750 -o radiusd -g radiusd
	dodir /var/log/radius
	keepdir /var/log/radius/radacct
	dodir /var/run/radiusd
	diropts

	make R="${D}" install || die "make install failed"
	dosed 's:^#user *= *nobody:user = radiusd:;s:^#group *= *nobody:group = radiusd:' \
	    /etc/raddb/radiusd.conf
	chown -R root:radiusd "${D}"/etc/raddb/*

	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}"
	gzip -f -9 "${D}/usr/share/doc/${PF}"/{rfc/*.txt,*}
	dodoc CREDITS

	rm "${D}/usr/sbin/rc.radiusd"

	newinitd "${FILESDIR}/radius.init" radiusd
	newconfd "${FILESDIR}/radius.conf" radiusd
}

pkg_preinst() {
	enewgroup radiusd
	enewuser radiusd -1 -1 /var/log/radius radiusd
}

pkg_prerm() {
	if [ "${ROOT}" = "/" ] && /etc/init.d/radiusd --quiet status ; then
		/etc/init.d/radiusd stop
	fi
}

pkg_postrm() {
	if [ "${ROOT}" = "/" ]; then
		ewarn "If radiusd service was running, it had been stopped!"
		echo
		ewarn "You should update the configuration files using etc-update or dispatch-conf"
		ewarn "and start the radiusd service again by running:"
		einfo "    /etc/init.d/radiusd start"

		ebeep
	fi
	ewarn "Auth-Type := Sql is no longer valid in /etc/raddb/users file!"
	ewarn "You should replace it with Auth-Type := Local."
}

