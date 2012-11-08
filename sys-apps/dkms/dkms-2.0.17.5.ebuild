# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils


DESCRIPTION="Dynamic Kernel Module Support"
SRC_URI="http://linux.dell.com/dkms/${P}.tar.gz"
HOMEPAGE="http://linux.dell.com/dkms"
LICENSE="GPL-2"
DEPEND=""
KEYWORDS="~x86 -*"
SLOT="0"

src_install () {
	doman dkms.8
	sed -i "s:prepare-all:prepare:g" ./dkms || die
	dosbin dkms
#	dosed "s:head -:head -n :g" /usr/sbin/dkms
#	dosed "s:tail -:tail -n :g" /usr/sbin/dkms
	dosbin dkms_mkkerneldoth
#	dosed "s:head -:head -n :g" /usr/sbin/dkms_mkkerneldoth
#	dosed "s:tail -:tail -n :g" /usr/sbin/dkms_mkkerneldoth
	# Not a Gentoo style init.d script
	#doinitd dkms_autoinstaller
	
	keepdir /var/lib/dkms
	insinto /var/lib/dkms
	doins dkms_dbversion

	keepdir /etc/dkms
	insinto /etc/dkms
	newins dkms_framework.conf framework.conf
	doins template-dkms-mkrpm.spec
	
	# Install documentation.
	dodoc AUTHORS COPYING sample.conf sample.spec
}
