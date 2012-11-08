# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Rsyslog is an enhanced syslogd supporting, among others, MySQL, syslog/tcp, fine grain output format control, and the ability to filter on any message part."
HOMEPAGE="http://www.rsyslog.com"
SRC_URI="http://download.rsyslog.com/rsyslog/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mysql postgres zlib kerberos static debug"
DEPEND="
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	zlib? ( sys-libs/zlib )
	kerberos? ( virtual/krb5 )
	"

RDEPEND="x11-apps/xconsole
	"

src_unpack() {
	unpack ${A}
	cd ${S}
#	sed -i -e "s:sysconfdir='\${prefix}/etc':sysconfdir='${prefix}/etc/rsyslog':" configure
}

src_compile() {
	local myconf=""

	if use mysql ; then
		myconf="${myconf} --enable-mysql"
	fi

	if use postgres ; then
		myconf="${myconf} --enable-pgsql"
	fi

	if use debug ; then
		myconf="${myconf} --enable-debug"
	fi

	if ! use zlib ; then
		myconf="${myconf} --disable-zlib"
	fi

	if use static ; then
		myconf="${myconf} --enable-static"
	fi

	if use kerberos ; then
		myconf="${myconf} --enable-gssapi-krb5"
	fi

	econf \
		--enable-largefile \
		--enable-regexp \
		--enable-pthreads \
		--enable-inet \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} INSTALL="install -D" install || die
	

	insinto /etc
        doins "${FILESDIR}"/rsyslog.conf
	
	# Install snippet for logrotate, which may or may not be installed
        insinto /etc/logrotate.d
        newins "${FILESDIR}/rsyslogd.logrotate" rsyslogd
	newinitd "${FILESDIR}/rsyslogd.init" rsyslogd
	newconfd "${FILESDIR}/rsyslogd.conf" rsyslogd
}
