# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
# mantainer: Ilya Kashirin (seclorum@seclorum.ru)
inherit eutils

DESCRIPTION="Acronis True Image Server  allows you to create an exact, live Linux server disk image"
HOMEPAGE="http://acronis.com"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/${PN}-${PV}.tar.gz"

LICENSE="Acronis"
KEYWORDS="~x86"
SLOT="0"

IUSE="mediabuilder"

DEPEND=""

RDEPEND="sys-block/snapapi26"

ACRONIS_HOME="/usr/lib/Acronis"

src_install() {

	dodir ${ACRONIS_HOME} || die
	dodir /etc/Acronis || die
	
	if ! use mediabuilder; then
		rm -Rf ${WORKDIR}/${PV}/MediaBuilder
		rm -f ${WORKDIR}/sbin/mediabuilder
	fi

	cp -R ${WORKDIR}/${PV}/* ${D}/${ACRONIS_HOME}/ || die "Install failed!"
	insinto /etc/Acronis
	doins ${WORKDIR}/etc/Acronis/*.config  || die

	dosbin ${WORKDIR}/sbin/*

	dosym ${ACRONIS_HOME}/TrueImageServer/TrueImage.desktop /usr/share/applications/TrueImage.desktop || die 

	if use mediabuilder; then
		dosym ${ACRONIS_HOME}/MediaBuilder/MediaBuilder.desktop /usr/share/applications/MediaBuilder.desktop || die
	fi
}
