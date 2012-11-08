# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 
#

inherit eutils versionator

MY_PV=$(replace_version_separator 2 '')

DESCRIPTION="Baudline is a time-frequency browser designed for scientific visualization of the spectral domain.  Signal analysis is performed by Fourier, correlation, and raster transforms that create colorful spectrograms with vibrant detail.  Conduct test and measurement experiments with the built in function generator, or play back audio files with a multitude of effects and filters.  The baudline signal analyzer combines fast digital signal processing, versatile high speed displays, and continuous capture tools for hunting down and studying elusive signal characteristics."

HOMEPAGE="http://www.baudline.com/"

SRC_URI="
x86? ( ${HOMEPAGE}/${PN}_${MY_PV}_linux_i686.tar.gz )
amd64? ( ${HOMEPAGE}/${PN}_${MY_PV}_linux_x86_64.tar.gz )
ppc? ( ${HOMEPAGE}/${PN}_${MY_PV}_linux_ppc.tar.gz )
"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
LICENSE="AS-IS"
SLOT="0"

RESTRICT="primaryurl"

RDEPEND="x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libSM
	x11-libs/libXp
jack? ( media-sound/jack-audio-connection-kit )
"

DEPEND="${RDEPEND}"

IUSE="jack"

S=${WORKDIR}/baudline_${MY_PV}_linux_i686
INSTALLDIR="/opt/${PN}"

pkg_nofetch() {
	einfo "May not be automatically fetched due to licensing"
	einfo "restrictions. You must manually fetch baudline_${MY_PV}_${MY_ARCH}.tar.gz from"
	einfo "${HOMEPAGE}/download.html. Once ${PN}"
	einfo "has been downloaded, move it to ${DISTDIR} and then"
	einfo "restart this ebuild"
}


src_unpack () {
	unpack ${A}
	cd ${S}
}

src_install() {
	dodir ${INSTALLDIR}/
	cp ${S}/baudline "${D}/${INSTALLDIR}/" || die "Install failed!"
	dosym ${INSTALLDIR}/baudline /usr/bin/baudline
	
	cp -R ${S}/icons "${D}/${INSTALLDIR}/" || die "Install failed!"
	cp -R ${S}/palettes "${D}/${INSTALLDIR}/" || die "Install failed!"

	if use jack; then
		cp ${S}/baudline_jack "${D}/${INSTALLDIR}/" || die "Install failed!"
		dosym ${INSTALLDIR}/baudline_jack /usr/bin/baudline_jack
	fi
	doicon ${FILESDIR}/baudline.png
	cat > baudline.desktop <<-EOF
		[Desktop Entry]
		Name=Baudline
		Type=Application
		Comment=Sound analyser
		Exec=baudline %f
		TryExec=baudline
		Icon=baudline.png
		Categories=Audio;Player;
		MimeType=audio/x-aiff;audio/basic;audio/x-mp3;audio/x-flac;audio/vorbis;audio/x-wav;audio/x-vorbis;audio/mpeg;audio/x-gsm;audio/x-voc;application/x-ogg;
	EOF
	
	insinto /usr/share/applications/
	doins baudline.desktop
	
	dodoc README mailcap.txt mime.types.txt
}

pkg_postinst() {
	einfo "Baudline has been installed."
	einfo "to run Baudline use \"baudline\""

	if use jack; then
		einfo "To run Baudline with Jack support use \"baudline_jack\""
	fi
	einfo "More information about usage Baudline you can obtain at http://baudline.com/manual/index.html"
}
