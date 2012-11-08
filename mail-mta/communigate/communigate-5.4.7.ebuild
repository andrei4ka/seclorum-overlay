# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# mantainer: Ilya Kashirin (seclorum@seclorum.ru)

EAPI="4"
inherit eutils rpm versionator user

MY_PV=$(replace_version_separator 2 '-')
MY_PV1=${PV%.*}

DESCRIPTION="CommuniGate Pro,the leading high-end Internet Messaging platform"
HOMEPAGE="http://www.stalker.com/CommuniGatePro/"
SRC_URI="amd64? ( ftp://ftp.communigate.com/pub/CommuniGatePro/${MY_PV1}/CGatePro-Linux-${MY_PV}.x86_64.rpm )
	 x86? ( ftp://ftp.communigate.com/pub/CommuniGatePro/${MY_PV1}/CGatePro-Linux-${MY_PV}.i386.rpm )
"

LICENSE="STALKER"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc mailwrapper mta"
RDEPEND=">=sys-libs/glibc-2.4
	    	mailwrapper? ( >=net-mail/mailwrapper-0.2 )
	mta? (
		!net-mail/mailwrapper
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/msmtp[mta]
		!mail-mta/nbsmtp
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
		!mail-client/mailx
	)"


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

src_install() {

	DIROPTIONS="--mode=0750 --owner=root --group=mail"
	dodir ${MYBASE}/

	dodir ${APPLICATION}/
	dodir /usr/doc/CommuniGate/
		

	cp -R ${S}/opt/CommuniGate/* "${D}/${APPLICATION}/" || die "Install failed!"
	if use doc ; then
		cp -R "${S}/usr/doc/CommuniGate/" "${D}/usr/doc/" || die "Install failed!"
	fi

	if use mta ; then
		dosym ${APPLICATION}/mail /usr/bin/mail
		dosym ${APPLICATION}/sendmail /usr/sbin/sendmail
	fi
	
	newinitd ${S}/communigate.init communigate
	newconfd ${FILESDIR}/communigate.conf communigate
}

pkg_postinst() {
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
