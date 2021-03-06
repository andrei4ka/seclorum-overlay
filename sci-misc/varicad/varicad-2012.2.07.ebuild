# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV1=${PV%.*.*}
MY_PV2=$(get_version_component_range 2-3)
DESCRIPTION="3D/2D mechanical CAD system"
HOMEPAGE="http://www.varicad.com/"
SRC_URI=" x86? ( http://www.varicad.com/userdata/files/release/en/varicad${MY_PV1}-en_${MY_PV2}_i386.deb )
	  amd64? ( http://www.varicad.com/userdata/files/release/en/varicad${MY_PV1}-en_${MY_PV2}_amd64.deb )"
RESTRICT="mirror"

LICENSE="Varicad"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=sys-libs/glibc-2.4.0
	>=sys-devel/gcc-4.1.1
	virtual/glu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXt
	"
RDEPEND="${DEPEND}
	x11-libs/libXinerama"

S=${WORKDIR}

src_compile() {
	einfo "nothing to compile"
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	cd "${S}"

	# removing not necessary content
	rm control.tar.gz data.tar.gz debian-binary \
		opt/VariCAD/desktop/*.sh \
		opt/VariCAD/desktop/varicad.mdkmenu \
		opt/VariCAD/desktop/varicad.wmconfig
	
	# NOTE: we need to strip some (useless) quotes
	sed -i 's:"::g' opt/VariCAD/desktop/varicad.desktop
}

src_install() {

	
	domenu opt/VariCAD/desktop/varicad.desktop || die "domenu failed."
	domenu opt/VariCAD/desktop/x-varicad.desktop || die "domenu mime-type failed."
	
	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/opt/VariCAD/desktop/varicad_${res}x${res}.png varicad.png
	done

	# installing the docs
	dodoc usr/share/doc/varicad${MY_PV1}-en/{README-en.txt,README.Debian,copyright,changelog.gz}
	rm usr/share/doc/varicad${MY_PV1}-en/*

	dodir /opt/VariCAD
	cp -pPR ${S}/opt/VariCAD/* "${D}"/opt/VariCAD || die "installing data failed"

	dosym /opt/VariCAD/bin/varicad /usr/bin/varicad
}


pkg_postinst() {
	echo ""
	einfo "If you get message \"Only root can activate\""
	einfo "then do register VariCAD under root and"
	einfo "chmod 644 /opt/VariCAD/lib/varicad.lck"
}
