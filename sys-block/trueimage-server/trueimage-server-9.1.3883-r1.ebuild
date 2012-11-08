# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
# mantainer: Ilya Kashirin (seclorum@seclorum.ru)
inherit eutils rpm

DESCRIPTION="Acronis True Image Server  allows you to create an exact, live Linux server disk image"
HOMEPAGE="http://acronis.com"
SRC_URI="TrueImageServer9.1_s_en.i686"

LICENSE="Acronis"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="mediabuilder"

DEPEND=""

RDEPEND="sys-block/snapapi26"

ACRONIS_HOME="/usr/lib/Acronis"
S=${WORKDIR}

src_unpack() {
	unzip ${DISTDIR}/TrueImageServer9.1_s_en.i686 -d ${WORKDIR}
	rpm_unpack ${S}/TrueImageClient-9.1.3883-1.i386.rpm
	if use mediabuilder; then
		rpm_unpack ${S}/MediaBuilder-9.1.3883-1.i386.rpm
	fi
}

src_install() {
	dodir ${ACRONIS_HOME} || die
	dodir /etc/Acronis || die
	dodir /var/lib/Acronis/TrueImage || die
	dosym /var/lib/Acronis/TrueImage /etc/Acronis/TrueImage

	cp -R ${WORKDIR}/usr/lib/Acronis/* ${D}/${ACRONIS_HOME}/ || die "Install failed!"
	
	insinto /etc/Acronis
	doins ${FILESDIR}/${PV}/*.config  || die

	dosbin ${WORKDIR}/usr/sbin/*

	dosym ${ACRONIS_HOME}/TrueImageServer/TrueImage.desktop /usr/share/applications/TrueImage.desktop || die 

	if use mediabuilder; then
		dosym ${ACRONIS_HOME}/MediaBuilder/MediaBuilder /usr/sbin/mediabuilder
		dosym ${ACRONIS_HOME}/MediaBuilder/MediaBuilder.desktop /usr/share/applications/MediaBuilder.desktop || die
	fi
	doman usr/share/man/man8/*
}
