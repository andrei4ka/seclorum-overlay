# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Firewall module for NetUP UTM."
HOMEPAGE="www.netup.ru"
SRC_URI="utm5-${PV}.tar.bz2"

LICENSE="NETUP"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RESTRICT="fetch nostrip"

RDEPEND="virtual/libc
		dev-libs/openssl
		app-admin/sudo
		sys-devel/gcc"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "http://www.netup.ru/"
	einfo "and move it to ${DISTDIR}"
}

PREVIOUS_INSTALLED="${T}/previous_installed"

pkg_setup() {
	echo "false" > ${PREVIOUS_INSTALLED}
	
	if [ -d /netup/utm5 ] ; then
		einfo "Previous installation found."
		echo "true" > ${PREVIOUS_INSTALLED}
	fi
}

src_unpack() {
	cd ${WORKDIR}
	tar -jxvf /usr/portage/distfiles/utm5-1.10.010.tar.bz2 netup/utm5/bin/utm5_rfw netup/utm5/rfw5.cfg
}

src_install() {
	cd ${WORKDIR}
	dodir /etc/utm5
	dodir /netup/utm5
	dodir /netup/utm5/log

	mv netup/utm5/rfw5.cfg ${D}/etc/utm5/ 
	dosym /etc/utm5/rfw5.cfg /netup/utm5/rfw5.cfg

	cp -a netup ${D}

	doinitd ${FILESDIR}/utm5_rfw
	doconfd ${FILESDIR}/utm5_rfw.conf

}

pkg_postinst() {
	echo
	einfo "To start utm5_rfw automaticaly during booting you need to run:"
	einfo "rc-update add utm5_rfw default"
	echo
	ewarn "Note: Configuration files are in /etc/utm5."
	echo
}
