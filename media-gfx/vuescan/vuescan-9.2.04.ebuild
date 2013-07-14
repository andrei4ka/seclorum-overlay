# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit eutils versionator

MY_PV=${PV%.*}
MY_PV=${MY_PV/./}
DESCRIPTION="A high-quality scanning and digital camera raw image processing software."
HOMEPAGE="http://www.hamrick.com/"
SRC_URI="
	  x86? ( http://www.hamrick.com/files/vuex32${MY_PV}.tgz -> ${P}_x32.tgz )
	  amd64? ( http://www.hamrick.com/files/vuex64${MY_PV}.tgz -> ${P}_x64.tgz )
	  http://www.hamrick.com/vuescan/${PN}.pdf"
RESTRICT="primaryuri"

LICENSE="vuescan"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

#MY_LINGUAS="ar bg ca cs da de el en es et fi fr gl he hi hr hu id it ja ko lt lv nl no pb pl pt ro ru sk sl sr sv ta th tl tr tw uk vi zh"

#for MY_LINGUA in ${MY_LINGUAS}; do
#	IUSE="${IUSE} linguas_${MY_LINGUA/-/_}"
#done



S="${WORKDIR}/VueScan"

DEPEND=""
RDEPEND=">=x11-libs/gtk+-2.0
	media-gfx/sane-backends
	"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_install() {
	# Remove unwanted LINGUAS:
#	for LINGUA in ${MY_LINGUAS}; do
#		if ! use linguas_${LINGUA/-/_}; then
#			rm -f lan_"${LINGUA}".txt
#		fi
#	done

	insinto /opt/vuescan
	doins vuescan.ds vuescan.8ba
	if use doc; then
		doins ${DISTDIR}/${PN}.pdf
	fi

	exeinto /opt/vuescan
	doexe vuescan
	doicon ${FILESDIR}/VueScan.png

	cat > vuescan.desktop <<-EOF
		[Desktop Entry]
		Name=VueScan
		Type=Application
		Comment=VueScan - easy scanning software
		Exec=/opt/vuescan/${PN}
		Icon=VueScan.png
		Categories=Graphics;Scanning;
	EOF
	
	insinto /usr/share/applications/
	doins vuescan.desktop
}

pkg_postinst() {
	einfo "VueScan expects the webbrowser Mozilla installed in your PATH."
	einfo "You have to change this in the 'Prefs' tab or make available"
	einfo "a symlink/script named 'mozilla' starting your favourite browser."
	einfo "Otherwise VueScan will fail to show the HTML documentation."

	einfo "To use scanner with Vuescan under user you need add user into scanner group."
	einfo "Just run under root: gpasswd -a username scanner"
	einfo ""
	einfo "To register Vuescan 9.1.12 use follow information:"
	einfo "E-mail address  : vsyopodhodit@yahoo.com " 
	einfo "Serial number   :  117214782"
	einfo "Customer number :   1265990638"
}

