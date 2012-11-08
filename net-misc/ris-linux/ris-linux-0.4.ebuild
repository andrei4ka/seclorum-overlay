# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator

DESCRIPTION="Ris Windows Installation"
HOMEPAGE="http://oss.netfarm.it/"
SRC_URI="http://oss.netfarm.it/guides/${P}.tar.gz
	ftp://seclorum.ru/etc/gentoo/portage/distfiles/lan-drivers-0.1.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="lan-drivers"

RDEPEND="net-fs/samba
	net-ftp/tftp-hpa
	dev-lang/python
	net-misc/dhcp
	sys-boot/syslinux
	"
INSTALLDIR=/opt/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/binlsrv-gentoo-specific.patch
	epatch ${FILESDIR}/infparser-gentoo-specific.patch
}

src_install() {
	rm -Rf ${S}/patches
	gcc binlsrv.c -o binlsrv
	dodir ${INSTALLDIR} || die
	insinto ${INSTALLDIR}
	doins -r ${S}/* || die
	newinitd ${FILESDIR}/binlsrv.init binlsrv
	newconfd ${FILESDIR}/binlsrv.conf binlsrv
	if use lan-drivers; then
		dodir /usr/share/${PN}/lan-drivers
		insinto /usr/share/${PN}/lan-drivers
		doins -r ${WORKDIR}/lan-drivers-0.1/*
	fi
	exeinto ${INSTALLDIR}
	doexe binlsrv.py
	doexe infparser.py

	dodir /var/lib/ris-linux
}

pkg_postinst() {
	einfo "ris-linux has been installed."
}
