# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=4

inherit eutils unpacker

DESCRIPTION="DrWeb virus scaner for Linux"
HOMEPAGE="http://www.drweb.com/"

if [ -n ${GLIBC_DRWEB} ]; then
    GLIBC_DRWEB="glibc26"
fi

IUSE_DRWEB_GLIBC="glibc22 glibc23 glibc24 glibc25 glibc26 glibc27"
IUSE_DREWB_MAIL="qmail exim postfix sendmail courier communigate zmailer"

MY_GLIBC=${GLIBC_DRWEB/c2/c2.}

SRC_URI="drweb-workstations_6.0.2.3-1209211901~linux_amd64.run"

RESTRICT="mirror strip"

SLOT="0"
LICENSE="DRWEB"
KEYWORDS="~x86"

IUSE="X doc linguas_ru logrotate drwebkey samba"


DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	dev-perl/libwww-perl
	virtual/cron
	logrotate? ( app-admin/logrotate )
	"

PROVIDE="virtual/antivirus"

S="${WORKDIR}"

INSTALLDIR="/opt/${PN}"
VARDRWEB="/var/${PN}"
SPOOLDRWEB="/var/spool/${PN}"
LOGDRWEB="/var/log/${PN}"
KEYDRWEB="${FILESDIR}/${P}.key"
UPDMIRRORSDRWEB="http\://www.rg-s.ru/base"

src_unpack() {

	cp "${DISTDIR}/drweb-workstations_6.0.2.3-1209211901~linux_amd64.run" ${WORKDIR}/1.run

	unpack_makeself "${WORKDIR}/1.run"
}

pkg_setup() {
	enewgroup drweb
	enewuser drweb -1 -1 ${VARDRWEB} drweb
}

src_compile() {
	einfo "Nothing to compile, installing DrWeb..."
}

src_install() {
	# Creating directories
	dodir ${INSTALLDIR} || die
	dodir ${LOGDRWEB} || die
	dodir ${SPOOLDRWEB} || die
	dodir ${VARDRWEB} || die
	dodir /etc/drweb || die

	rm -rf ${S}/var/drweb/spool
	rm -rf ${S}/var/drweb/log

	cp -pPR ${S}/opt/drweb/* ${D}/${INSTALLDIR}
	cp -pPR ${S}/var/drweb/* ${D}/${VARDRWEB}
	cp -pPR ${S}/etc/drweb/* ${D}/etc/drweb

	# Set up permissions
	fowners drweb:drweb ${INSTALLDIR}/lib
	fowners drweb:drweb ${VARDRWEB}/{bases,infected,run,updates}
	fowners drweb:drweb /etc/drweb/email.ini
	fowners drweb:drweb ${LOGDRWEB}
	fowners drweb:drweb ${SPOOLDRWEB}
	fperms 0640 /etc/drweb/email.ini
	fperms 0750 ${VARDRWEB}/infected
	fperms 0700 ${VARDRWEB}/run
	fperms 0700 ${VARDRWEB}/updates
	fperms 0770 ${SPOOLDRWEB}
	chown -R drweb:drweb "${D}"${VARDRWEB}/bases
	chown -R drweb:drweb "${D}"${INSTALLDIR}/lib

	if use logrotate ; then
		insinto /etc/logrotate.d
		newins "${D}"/etc/drweb/drweb-log drweb
	fi
	rm -f "${D}"/etc/drweb/drweb-log

	newinitd ${WORKDIR}/drwebd.init drwebd
	newconfd ${WORKDIR}/drwebd.conf drwebd

	local docdir="${D}${INSTALLDIR}/doc"
	for doc in "${docdir}"/{ChangeLog,FAQ,readme.{eicar,license}} \
	"${docdir}"/{daemon/readme.daemon,scanner/readme.scanner,update/readme.update}
	do
		dodoc ${doc} && rm -f ${doc}
		if use linguas_ru; then
			dodoc ${doc}.rus && rm -f ${doc}.rus
		fi
	done
	dodoc "${D}"${INSTALLDIR}/getkey.HOWTO
	use linguas_ru && dodoc "${D}"${INSTALLDIR}/getkey.rus.HOWTO

	rm -rf "${docdir}" && rm -f "${D}"${INSTALLDIR}/getkey.*

	use doc && dodoc "${WORKDIR}/drwunxen.pdf"
	use doc && use linguas_ru && dodoc "${WORKDIR}/drwunxru.pdf"

	if use drwebkey; then
		insinto /etc/drweb
		newins ${KEYDRWEB} drweb32.key
	fi

	if use X; then
		exeinto ${INSTALLDIR}
		doexe ${WORKDIR}/${PN}-x-${PV}-${MY_GLIBC}/opt/drweb/drweb-gui || die
		cp -pPR ${WORKDIR}/${PN}-x-${PV}-${MY_GLIBC}/opt/drweb/lng ${D}/${INSTALLDIR}
		insinto /usr/share/pixmaps
		newins ${WORKDIR}/${PN}-x-${PV}-${MY_GLIBC}/usr/share/pixmaps/DrWeb32w.png drweb.png
		
	fi

	cat > drweb.desktop <<-EOF
		[Desktop Entry]
		Encoding=UTF-8
		Name=Dr.Web Scanner
		Comment=Antivirus Scanner
		Exec=xdrweb
		Icon=drweb.png
		Type=Application
		X-Desktop-File-Install-Version=0.2
		Categories=Application;System;
	EOF
	
	insinto /usr/share/applications/
	doins drweb.desktop

	dosym ${INSTALLDIR}/drweb-gui /usr/bin/xdrweb
}

pkg_postinst() {
	elog
	elog " Create a cron entry for DrWeb auto updates in a similar manner:"
	elog
	elog " crontab -u drweb -e"
	elog
	elog " and add the following line (change the frequency of update if required):"
	elog
	elog " * */4 * * *     if [ -x ${INSTALLDIR}/update/update.pl ]; then ${INSTALLDIR}/update/update.pl; fi"
	elog

	elog
	elog "To configure DrWeb, edit /etc/drweb/drweb32.ini as needed."
	elog

	if use logrotate ; then
		elog "DrWeb logrotate script has been provided."
		elog "Edit /etc/logrotate.d/drweb as needed."
	fi

	ewarn
	ewarn "IMPORTANT!!!"
	ewarn
	ewarn "If you don't have a license for DrWeb, go to http://download.drweb.com/demo/ "
	ewarn "to obtain a demo licence."
	ewarn
	ewarn "Additional information can be obtained from /usr/share/doc/${PF}/readme.license"
}
