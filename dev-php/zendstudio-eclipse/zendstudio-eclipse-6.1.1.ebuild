# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
# mantainer: Ilya Kashirin (seclorum@seclorum.ru)
inherit eutils versionator

MY_PV1=${PV%.*.*}

DESCRIPTION="Power PHP IDE"
HOMEPAGE="http://zend.com/"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/${P}.tar.bz2"

LICENSE="ZEND"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="x11-base/xorg-server"

DEPEND=""

S=${WORKDIR}/${PN}

INSTALLDIR=/opt/${PN}
src_unpack() {
	unpack ${A}
	cd ${S}

#	if [ ${ZENDSTUDIO_USER} ]; then
#		sed -i -e "s:USER_NAME=Evaluation User:USER_NAME=${ZENDSTUDIO_USER}:g"  bin/ZendIDE.config || die
#	fi
#
#	if [ ${ZENDSTUDIO_SERIAL} ]; then
#		sed -i -e "s:LICENSE_KEY=3007209C26012017990:LICENSE_KEY=${ZENDSTUDIO_SERIAL}:g"  bin/ZendIDE.config || die
#	fi
}

src_compile() {
	echo "Nothing to compile."
}

src_install() {
	dodir ${INSTALLDIR}
	cp -R ${S}/* ${D}/${INSTALLDIR}/ || die "Install failed!"

	insinto /usr/share/icons
	 newins icon.xpm zendstudioeclipse.xpm

	cat > zendstudioeclipse.desktop <<-EOF
		[Desktop Entry]
		Version=${PV}
		Type=Application
		Name=Zend Studio for Eclipse
		Comment=Zend Studio for EclipseIntegrated Development Environment
		Exec=${INSTALLDIR}/ZendStudio
		Icon=zendstudioeclipse.xpm
		Categories=Development;IDE
		MimeType=application/x-php;
	EOF

#	for res in 16 32 48 64; do
#		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
#		newins "${S}"/bin/icon${res}_studio.png zendstudio.png
#		rm -f ${D}/${INSTALLDIR}/bin/icon${res}_studio.png
#	done
	
	insinto /usr/share/applications/
	doins zendstudioeclipse.desktop
}
