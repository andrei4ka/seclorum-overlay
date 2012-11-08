# Copyright 1999-2008 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils bash-completion

DESCRIPTION="Dynamic Kernel Module Support"
SRC_URI="http://linux.dell.com/dkms/permalink/${P}.tar.gz"
HOMEPAGE="http://linux.dell.com/dkms"
LICENSE="GPL-2"
DEPEND=""
KEYWORDS="~x86"
SLOT="0"
RESTRICT="nomirror"

src_compile() {
	sed -i "s:prepare-all:prepare:g" ./dkms || die
	echo "Nothing compile"
}

src_install() {
	dosbin dkms
	dosbin dkms_mkkerneldoth
	
	keepdir /var/lib/dkms
	insinto /var/lib/dkms
	doins dkms_dbversion

	keepdir /etc/dkms
	insinto /etc/dkms
	newins dkms_framework.conf framework.conf
	doins template-dkms-mkrpm.spec
	
	doman dkms.8
	dodoc AUTHORS COPYING sample.conf sample.spec
	
	if use bash-completion; then
		dobashcompletion ./dkms.bash-completion
	fi
}
