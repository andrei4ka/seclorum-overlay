# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ilya Kashirin (seclorum@seclorum.ru)

inherit eutils versionator linux-mod flag-o-matic

MY_PV=$(replace_version_separator 3 '-')
MY_PV1=${PV%.*}

DESCRIPTION="SnapApi modules for Acronis True Image Server for Linux"
HOMEPAGE="http://www.acronis.ru/"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/${PN}-${MY_PV1}-all.tar.gz"

LICENSE="ACRONIS"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=""
DEPEND="app-arch/rpm2targz
	>=sys-apps/dkms-2.0.16"

MARCH=`get-flag march`

S=${WORKDIR}

src_unpack () {
	unpack ${A}
	cd ${S}
}

src_install() {
	dodir /usr/src/${PN}-${MY_PV1}
	cp -R ${S}/dkms_source_tree/* ${D}/usr/src/${PN}-${MY_PV1} || die "Install failed!"
}

pkg_postinst() {
	echo ""
	einfo "Sources of ${PN}-${MY_PV1} has installed. To compile and install ${PN} kernel module you need do follow:"
	einfo "dkms add -m ${PN} -v ${MY_PV1}"
	einfo "dkms build -m ${PN} -v ${MY_PV1} --config /boot/config-${KV_FULL} --arch ${MARCH} --kernelsourcedir ${KV_DIR}"
	einfo "dkms install -m ${PN} -v ${MY_PV1} --config /boot/config-${KV_FULL} --arch ${MARCH} --kernelsourcedir ${KV_DIR}"
	einfo "modprobe ${PN}"
	echo ""
}
