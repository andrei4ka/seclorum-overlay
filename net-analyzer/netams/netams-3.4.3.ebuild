# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils versionator

#MY_PV=$(replace_version_separator 3 '')

DESCRIPTION="NetAMS Traffic Accounting"
HOMEPAGE="http://www.netams.com"
SRC_URI="http://www.netams.com/files/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

IUSE="berkdb debug mysql postgres netflow pam"

DEPEND="berkdb? ( sys-libs/db )
	mysql? ( >=dev-db/mysql-4 )
	postgres? ( >=dev-db/postgresql-server-7.4 )
	netflow? ( net-analyzer/FlowScan )
	pam? ( sys-libs/pam )
	net-firewall/iptables
	>=net-libs/libpcap-0.7
	"
	
S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A} ; cd ${S}
	if use amd64 ; then
		epatch ${FILESDIR}/${PV}/netams-x86-64.patch
	fi

	# disable debug mode
	if use !debug
	then
		sed -ie "s:if \[ ! \"x\$1\" = \"x-nodebug:if \[ \"x\$1\" = \"x-nodebug:g" configure.sh
	fi

	# disable pam
	if use !pam
	then
		sed -ie "s:locate_file \"security/pam_appl.h\" \&\& v1=\$var \&\& locate_file \"libpam.so\" \&\& v2=\$var:locate_file \"security/pam_appl.h\" \&\& v1=\"\" \&\& locate_file \"libpam.so\" \&\& v2=\"\":g" configure.sh
	fi
	
	sed -ie "s:/etc/netams.cfg:/etc/netams/netams.cfg:g" addon/netams-gentoo.sh
}

src_compile() {
# FIXME work around configuring
	emake -j1 || die "emake failed" # no accept $MAKEOPTS
}

src_install() {
	dosbin src/netams src/netamsctl src/flowprobe src/ascii2netflow src/ulog2netflow
	newinitd addon/netams-gentoo.sh netams
	dodir /etc/netams
	insinto /etc/netams
	insopts -m0644
	newins addon/netams.cfg netams.cfg.sample
	doman doc/*.8
	dodoc doc/README doc/TODO.txt
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r \
		addon/ru-networks.txt \
		addon/mysql_rotate.pl \
		addon/postgresql_schema.sql \
		cgi-bin \
		# where place it?
		# for apache - /var/www/localhost
		#addon/oracle
}

pkg_postinst()
{
	ewarn ""
	ewarn "CGI scripts are installed into /usr/share/${PN}/cgi-bin"
	ewarn "You should copy them to appropriate place."
	ewarn "Example of config file placed into /etc/${PN}/${PN}.cfg.sample"
	ewarn "For autostart type"
	ewarn "    rc-update add netams default"
	ewarn ""
	ewarn "And PLEASE READ THE DOCUMENTATION FIRST!"
	ewarn "${HOMEPAGE}/doc/index.html"
	ewarn ""
}
