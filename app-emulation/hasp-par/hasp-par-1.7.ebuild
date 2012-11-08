# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic linux-mod linux-info

DESCRIPTION="HASP driver parallel port"
HOMEPAGE="http://www.aladdin.com"
SRC_URI="x86? ( ftp://ftp.aladdin.com/pub/aladdin.de/hardlock/linux/v1.7/i386/aksparlnx-1.7-i386.tar.gz )
	amd64? ( ftp://ftp.aladdin.com/pub/aladdin.de/hardlock/linux/v1.7/x86_64/aksparlnx-1.7-x86_64.tar.gz )"
LICENSE="Proprietary"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="kernel_linux"

DEPEND="kernel_linux? ( virtual/linux-sources )"

pkg_setup() {
	if use kernel_linux ; then
		use x86 && MODULE_NAMES="aksparlnx(aksparlnx:${WORKDIR}/aksparlnx-${PV}-i386)"
		use amd64 && MODULE_NAMES="aksparlnx(aksparlnx:${WORKDIR}/aksparlnx-${PV}-x86_64)"
		CONFIG_CHECK="PARPORT PARPORT_PC"

		linux-mod_pkg_setup
		kernel_is 2 6 && BUILD_PARAMS="KERNSRC=${KERNEL_DIR}" BUILD_TARGETS="kernel26"
		kernel_is 2 4 && BUILD_PARAMS="KERNSRC=${KERNEL_DIR}" BUILD_TARGETS="kernel24"

	fi
}

src_unpack() {
	if use x86; then
	    unpack "aksparlnx-"${PV}"-i386.tar.gz"
	    cd "${WORKDIR}"/aksparlnx-"${PV}"-i386
	fi
	
	if use amd64; then
	    unpack "aksparlnx-"${PV}"-x86_64.tar.gz"
	    cd "${WORKDIR}"/aksparlnx-"${PV}"-x86_64
	fi
	epatch "${FILESDIR}"/aksparpub.c.patch
	epatch "${FILESDIR}"/gcc.patch
}


src_compile() {
	if use kernel_linux ; then
		if use x86; then 
		    cd "${WORKDIR}"/aksparlnx-"${PV}"-i386
		    ARCH="i386" emake "${BUILD_PARAMS}" "${BUILD_TARGETS}"
		fi
		
		if use amd64; then 
		    cd "${WORKDIR}"/aksparlnx-"${PV}"-x86_64
		    ARCH="x86_64" emake "${BUILD_PARAMS}" "${BUILD_TARGETS}"
		fi
	fi
}

src_install() {
	if use kernel_linux ; then
		linux-mod_src_install
	fi
}

pkg_postinst() {
	use kernel_linux && linux-mod_pkg_postinst
	
	elog ""
	elog "Don't forget to add module cifs to /etc/modules.autoload.d/kernel-2.?"
	elog ""
	elog "To make the driver accessible, the /dev/Hardlock device node has to be"
	elog "generated, specifying the same major number used to load the driver"
	elog "(major=xxx command line to insmod, or 42 default)."
	elog ""
	elog "The device node is generated with the following command:"
	elog ""
	elog "	mknod /dev/Hardlock c 42 0"
	elog ""
	elog "To set access mode to the node as "allow everyone":"
	elog ""
	elog "	chmod 666 /dev/Hardlock"
	elog ""
}
