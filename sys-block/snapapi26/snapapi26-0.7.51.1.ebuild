# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ilya Kashirin (seclorum@seclorum.ru)

inherit eutils rpm versionator linux-mod flag-o-matic

MY_PV=$(replace_version_separator 3 '-')
MY_PV1=${PV%.*}

DESCRIPTION="SnapApi modules for Acronis True Image Server for Linux"
HOMEPAGE="http://www.acronis.ru/"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/${PN}_modules-${MY_PV}.noarch.rpm"


LICENSE="ACRONIS"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=""
DEPEND="app-arch/rpm2targz
	>=sys-apps/dkms-2.0.16"

MARCH=`get-flag march`

S="${WORKDIR}"

src_unpack () {
	rpm_src_unpack ${A}
	cd ${S}
	unpack ./usr/lib/Acronis/kernel_modules/${PN}-${MY_PV1}-all.tar.gz
	sed -i "s:#include <linux/autoconf.h>::" dkms_source_tree/snapapi26.c  || die "sed failed"
	sed -i "s:#include <linux/autoconf.h>::" dkms_source_tree/snumbd26.c  || die "sed failed"
}

src_install() {

	dodir /usr/src/${PN}-${MY_PV1}
	cp -R ${S}/dkms_source_tree/* ${D}/usr/src/${PN}-${MY_PV1} || die "Install failed!"
}

pkg_postinst() {
	echo ""
	einfo "Sources of ${PN}-${MY_PV1} has installed. To compile and install ${PN} kernel module you need do follow:"
	einfo "mount /boot"
	einfo "dkms add -m ${PN} -v ${MY_PV1}"
	einfo "dkms build --no-clean-kernel -m ${PN} -v ${MY_PV1} --config /boot/config-${KV_FULL} --arch ${MARCH} --kernelsourcedir ${KV_DIR}"
	einfo "dkms install --no-clean-kernel -m ${PN} -v ${MY_PV1} --config /boot/config-${KV_FULL} --arch ${MARCH} --kernelsourcedir ${KV_DIR}"
	einfo "modprobe ${PN}"
	einfo "modprobe snumbd26"
	echo ""
}
