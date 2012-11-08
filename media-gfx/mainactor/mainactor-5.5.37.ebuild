# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator
MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="Main Actor - Linux video editing"
HOMEPAGE="http://www.mainconcept.com/"
SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/${PN}-${MY_PV}.tar.bz2"

LICENSE="MAINACTOR"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libSM
	x11-libs/libxcb
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXdmcp
	media-libs/fontconfig
	media-libs/libmng
	media-libs/alsa-lib
	media-libs/jpeg
	media-libs/freetype
	sys-libs/zlib
	dev-libs/libxml2
	media-libs/nas
	"

S="${WORKDIR}/${PN}-${MY_PV}"

INSTALLDIR="/opt/${PN}"

QA_TEXTRELS="opt/MainConcept/MainActor/libraries/gfl/libmvl.io-gfl.so.1.0.0
 opt/MainConcept/MainActor/libraries/mpeg/libmvl.io-mpeg.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.2dtext.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.wav.so
 opt/MainConcept/MainActor/libraries/libmvl.mveffects.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io_dvavi_type2.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.mceffects.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io_mjpg.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io_png.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.mcaudiofilters.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io_dvdzl.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io_dvdif.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io-exr.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.DVCapture.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.mctransitions.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.io_dvavi_type1.so.1.0.0
 opt/MainConcept/MainActor/libraries/libmvl.ogg.so
 usr/lib/MainConcept/MainActor/libmcmpgvout.001
 usr/lib/MainConcept/MainActor/libmcmpgvout.002
 usr/lib/MainConcept/MainActor/libmcmpgvout.003
 usr/lib/MainConcept/MainActor/libmcmpgvout.004
 usr/lib/MainConcept/MainActor/libgfl.so.2.54
 usr/lib/MainConcept/MainActor/libmcpcmaout.so
 usr/lib/MainConcept/MainActor/libmcmpegin.so
 usr/lib/MainConcept/MainActor/libmcmpgaout.so
 usr/lib/MainConcept/MainActor/libmcsr_wrap.so
 usr/lib/MainConcept/MainActor/libmcmpgvout.so
 usr/lib/MainConcept/MainActor/libmcdvd_32.so
 usr/lib/MainConcept/MainActor/libmcmpgcheck.so
 usr/lib/MainConcept/MainActor/libmcmpgdec.so
 usr/lib/MainConcept/MainActor/libmcmpgmux.so
 usr/lib/MainConcept/MainActor/libmcmpgdmux.so"

src_unpack() {
	unpack ${A}
	cd ${S}
	unpack ./${PN}-${MY_PV}.i386.ubuntu-6.06.deb || die
	unpack ./data.tar.gz || die
	sed -i -e "s:Exec=mactor:Exec=${INSTALLDIR}/mactor:" usr/share/applications/MainActor-5.desktop
	sed -i -e "s:Icon=MainActor-5:Icon=mainactor:" usr/share/applications/MainActor-5.desktop
	mv usr/share/applications/MainActor-5.desktop usr/share/applications/mainactor.desktop
	mv usr/share/pixmaps/MainActor-5.xpm usr/share/pixmaps/mainactor.xpm
}

src_install()
{
        dodir ${INSTALLDIR}
#        dodir /usr

        cp -r ${S}/opt/MainConcept/MainActor/* ${D}/${INSTALLDIR}
	cp ${S}/mactor.key ${D}/${INSTALLDIR}
	
	dodir /usr/lib/MainConcept
	cp -r ${S}/usr/lib/MainConcept/* ${D}/usr/lib/MainConcept
	
	
	insinto /usr/share/applications/
	doins ${S}/usr/share/applications/mainactor.desktop
	
	insinto /usr/share/pixmaps/
	doins ${S}/usr/share/pixmaps/mainactor.xpm

#        find ${D} -type d |  xargs chmod 755
}