# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ written by Ilya Kashirin (email: seclorum@gmail.com)

EAPI="4"

# needed by make_desktop_entry
inherit eutils flag-o-matic

MY_PN="Sublime%20Text%202.0.1"
MY_P="${MY_PN}%20${PV}"
S="${WORKDIR}/Sublime Text 2"

DESCRIPTION="Sublime Text is a sophisticated text editor for code, html and prose"
HOMEPAGE="http://www.sublimetext.com"
COMMON_URI="http://c758482.r82.cf2.rackcdn.com"
SRC_URI="amd64? ( ${COMMON_URI}/${MY_PN}%20x64.tar.bz2 )
	x86? ( ${COMMON_URI}/${MY_PN}.tar.bz2 )"
LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"


DEPEND="dev-util/bsdiff"

RDEPEND="media-libs/libpng:1.2
	>=x11-libs/gtk+-2.24.8-r1:2"

src_unpack(){
	unpack ${A}
	cd "${S}"
	mv sublime_text sublime_text.ori
	if [ "${ARCH}" == "x86" ]; then
	    bspatch "${S}/sublime_text.ori" "${S}/sublime_text" "${FILESDIR}/${P}.register.x86.patch"
	elif [ "${ARCH}" == "amd64" ]; then
	    bspatch "${S}/sublime_text.ori" "${S}/sublime_text" "${FILESDIR}/${P}.register.x64.patch"
	fi
	cp ${FILESDIR}/License.sublime_license "${S}"/
}

src_install() {
	insinto /opt/${PN}
	into /opt/${PN}
	exeinto /opt/${PN}
	doins -r "lib"
	doins -r "Pristine Packages"
	doins "sublime_plugin.py"
	doins "PackageSetup.py"
	doins "License.sublime_license"
	doexe "sublime_text"
	dosym "/opt/${PN}/sublime_text" /usr/bin/sublime_text
	newicon ${FILESDIR}/sublime_text.ico sublime_text.ico
	make_desktop_entry "sublime_text" "Sublime Text Editor" "/usr/share/pixmaps/sublime_text.ico" "Application;TextEditor"

}


pkg_postinst() {
	echo "To register Sublime-text use follow:"
	echo "-----BEGIN LICENSE-----"
	echo "Seclorum"
	echo "Unlimited User License"
	echo "EA7E-25734"
	echo "DEABFB59A24E30AC3C02C2AF3B0DBF16"
	echo "CC2E853EEB5171475C21E90D22C1E61D"
	echo "B6C40B14793315E37AD1E7402C32AE76"
	echo "363FF2B6A4BA4A56C2FCF5AF909262F9"
	echo "1B7359D2DEA7CB9B9ABAFE71E9B44084"
	echo "201CC63D90AB375150CF6EC6B0B324D5"
	echo "77D4BB6F9D808B5CA94C61AFC12A6E95"
	echo "3A130DE5BF7DB61255ADE2F413FE3B3C"
	echo "-----END LICENSE-----"
}
