# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# mantainer: Ilya Kashirin (seclorum@gmail.com)
EAPI="5"

inherit eutils rpm versionator

MY_PV=$(replace_version_separator 2 '-')
MY_PV1=${PV%.*}

DESCRIPTION="CommuniGate Pro,the leading high-end Internet Messaging platform"
HOMEPAGE="http://www.stalker.com/CommuniGatePro/"
SRC_URI="x86? ( ftp://ftp.communigate.com/pub/CommuniGatePro/${MY_PV1}/CGatePro-Linux-${MY_PV}.i386.rpm \
         http://www.communigate.com/pub/CommuniGatePro/${MY_PV1}/CGatePro-Linux-${MY_PV}.i386.rpm )
         amd64? ( ftp://ftp.communigate.com/pub/CommuniGatePro/${MY_PV1}/CGatePro-Linux-${MY_PV}.x86_64.rpm \
         		http://www.communigate.com/pub/CommuniGatePro/${MY_PV1}/CGatePro-Linux-${MY_PV}.x86_64.rpm )
         "

LICENSE="STALKER"
SLOT="5"
KEYWORDS="~x86 ~amd64"
IUSE="doc +mta_system +mail_system cluster"
RDEPEND=">=sys-libs/glibc-2.4
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/qmail-ldap
	mta_system? ( !mail-mta/sendmail )
	!mail-mta/opensmtpd
	!<mail-mta/ssmtp-2.64-r2
	!>=mail-mta/ssmtp-2.64-r2[mta]
	!net-mail/fastforward
	mail-mta/postfix
	mail_system? ( !mail-client/mailx )
	cluster? ( sys-cluster/ipvsadm ) 
	"
	
#PROVIDE="virtual/mta virtual/mda virtual/imapd virtual/mailx"

APPLICATION="/opt/CommuniGate"
MYBASE="/var/CommuniGate"

S=${WORKDIR}



src_unpack () {
	rpm_src_unpack ${A}
	cd ${S}
	cp ${FILESDIR}/communigate.init ${S}
	sed -i -e "s:APPLICATION=\"/opt/CommuniGate\":APPLICATION=\"${APPLICATION}\":" communigate.init
	sed -i -e "s:MYBASE=\"/var/CommuniGate\":MYBASE=\"${MYBASE}\":" communigate.init
}

pkg_setup() {
	enewgroup mail 12
}

src_install() {

	DIROPTIONS="--mode=0750 --owner=root --group=mail"
	dodir ${MYBASE}/

	dodir ${APPLICATION}/
	dodir /usr/doc/CommuniGate/
		

	cp -R ${S}/opt/CommuniGate/* "${D}/${APPLICATION}/" || die "Install failed!"
	if use doc ; then
		cp -R "${S}/usr/doc/CommuniGate/" "${D}/usr/doc/" || die "Install failed!"
	fi

	if use mta_system ; then
		dosym ${APPLICATION}/mail /usr/bin/mail
		dosym ${APPLICATION}/sendmail /usr/sbin/sendmail
	fi
	
	newinitd ${S}/communigate.init communigate
	newconfd ${FILESDIR}/communigate.conf communigate
}

pkg_postinst() {
	einfo "The CommuniGate Pro server has been installed."
	einfo ""
	einfo "Use \`rc-update add communigate default\` if you"
	einfo "want communigate start when boot"
	einfo ""
	einfo "If you are installing the Server for the first time,"
	einfo "connect to the Server using any Web Browser: <http://yourhost:8010>"
	einfo "and initialize the postmaster password"
	einfo ""
	einfo "The postmaster password will be stored in"
	einfo "/var/CommuniGate/Accounts/postmaster.macnt/account.settings"
	einfo "file."
	einfo ""
	einfo "Check the General Settings and verify that the Server Main Domain"
	einfo "is correct - it should be the FULL domain of your system, i.e."
	einfo "it should be \"department.company.com\", but not just \"department\"."
	einfo ""
	einfo "Then proceed with registering users."
	einfo ""
	einfo "See <http://www.stalker.com/CommuniGatePro/> for the complete documentation."
}
