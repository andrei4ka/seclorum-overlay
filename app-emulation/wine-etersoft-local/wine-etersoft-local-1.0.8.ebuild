# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit rpm

MY_P="wine-etersoft-local-1.0.8"
DESCRIPTION="WINE@Etersoft Local, a addon for WINE@Etersoft for office application, as such as 1C:Predpryatie"
HOMEPAGE="http://www.etersoft.ru/"
SRC_URI="${MY_P}-alt0.M40.7.i586.tar.gz"

LICENSE="WINE@Etersoft-Local Corp.WINE@Etersoft-Local"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
#IUSE="alsa arts cups dbus esd hal jack jpeg lcms ldap nas ncurses opengl oss scanner xml X"
RESTRICT="fetch strip"

		 
RDEPEND=">=media-libs/freetype-2.0.0
	!app-emulation/wine
	!app-emulation/wine-etersoft-network
	!app-emulation/wine-etersoft-sql
	>=app-emulation/wine-etersoft-public-${PV}
	>=dev-libs/openssl-0.9.8g
	media-fonts/corefonts"

pkg_nofetch() {
	einfo "Please download the appropriate WINE@Etersoft-Local archive (${MY_P}-alt0.M40.7.i586.rpm)"
	einfo "from ${HOMEPAGE} (requires a Etersoft subscription)"
	einfo
	einfo "Then put the file in ${DISTDIR}"
}

src_unpack () {
        echo "${DISTDIR}/${A}"
	unpack "${MY_P}-alt0.M40.7.i586.tar.gz"
	cp -p "${FILESDIR}"/eter_acl "${WORKDIR}"/usr/bin/
}

src_install() {
	dodir /etc/init.d
	dodir /etc/wine
	cp "${FILESDIR}"/etersafe.init-1.0.9 "${D}"/etc/init.d/etersafed || die "cp usr"
	cp -R "${WORKDIR}"/usr "${D}" || die "cp usr"
	cp -R "${WORKDIR}"/etc/wine/* "${D}"/etc/wine/ || die "cp /etc/wine"
	
}

pkg_postinst() {
	cd /usr/lib
	ln -s libcrypto.so libcrypto.so.6
	ln -s libssl.so libssl.so.6
	
	einfo "Run /usr/bin/wine to start wine as any non-root user."
	einfo "This will take care of creating an initial environment"
	einfo " and do everything else."
	einfo ""
}
