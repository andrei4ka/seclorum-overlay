# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
# mantainer: Ilya Kashirin (seclorum@seclorum.ru)
inherit eutils versionator

MY_PV1=${PV%.*.*}

DESCRIPTION="Power PHP IDE"
HOMEPAGE="http://zend.com/"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/${PN}-${PV}.tar.bz2"

LICENSE="ZEND"
SLOT="${MY_PV1}"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=dev-java/sun-jdk-1.5*
	x11-base/xorg-server"

DEPEND=""

INSTALLDIR=/opt/${PN}${MY_PV1}
src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:/opt/zendstudio-5.5.1:${INSTALLDIR}:g" bin/php4/php.ini || die
	sed -i -e "s:/opt/zendstudio-5.5.1:${INSTALLDIR}:g" bin/php5/php.ini || die
	sed -i -e "s:/opt/zendstudio-5.5.1:${INSTALLDIR}:g" bin/ZDE.lax || die

	if [ ${ZENDSTUDIO_USER} ]; then
		sed -i -e "s:USER_NAME=Evaluation User:USER_NAME=${ZENDSTUDIO_USER}:g"  bin/ZendIDE.config || die
	fi

	if [ ${ZENDSTUDIO_SERIAL} ]; then
		sed -i -e "s:LICENSE_KEY=3007209C26012017990:LICENSE_KEY=${ZENDSTUDIO_SERIAL}:g"  bin/ZendIDE.config || die
	fi
}

src_compile() {
	echo "Nothing to compile."
}

src_install() {
	dodir ${INSTALLDIR}
	cp -R ${S}/* ${D}/${INSTALLDIR}/ || die "Install failed!"

	cat > zendstudio.desktop <<-EOF
		[Desktop Entry]
		Version=${PV}
		Type=Application
		Name=Zend Studio
		Comment=Zend Studio Integrated Development Environment
		Exec=${INSTALLDIR}/bin/ZDE
		Icon=zendstudio.png
		Categories=Application;Development;
		MimeType=application/x-php;
	EOF

	for res in 16 32 48 64; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins "${S}"/bin/icon${res}_studio.png zendstudio.png
		rm -f ${D}/${INSTALLDIR}/bin/icon${res}_studio.png
	done
	
	insinto /usr/share/applications/
	doins zendstudio.desktop
}
