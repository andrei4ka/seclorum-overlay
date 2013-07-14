# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ written by Ilya Kashirin (email: seclorum@gmail.com)

EAPI="4"

# needed by make_desktop_entry
inherit eutils flag-o-matic

MY_PN="Sublime%20Text%202.0.1"
MY_P="${MY_PN}%20${PV}"
S="${WORKDIR}/sublime_text_3"

DESCRIPTION="Sublime Text is a sophisticated text editor for code, html and prose"
HOMEPAGE="http://www.sublimetext.com"
COMMON_URI="http://c758482.r82.cf2.rackcdn.com"
SRC_URI="amd64? ( ${COMMON_URI}/sublime_text_3_build_3047_x64.tar.bz2 ) 
	x86? ( ${COMMON_URI}/sublime_text_3_build_3047_x32.tar.bz2 )"
LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"


DEPEND="dev-util/bsdiff"

RDEPEND="
	>=x11-libs/gtk+-2.24.8-r1:2"

src_unpack(){
	unpack ${A}
	cd "${S}"
	cp ${FILESDIR}/License.sublime_license "${S}"/
}

src_install() {
	insinto /opt/${PN}
	into /opt/${PN}
	exeinto /opt/${PN}
	doins -r *
	doexe "sublime_text"
	doexe "plugin_host"
	dosym "/opt/${PN}/sublime_text" /usr/bin/sublime_text
	newicon ${FILESDIR}/sublime_text.ico sublime_text.ico
	make_desktop_entry "sublime_text" "Sublime Text Editor" "/usr/share/pixmaps/sublime_text.ico" "Application;TextEditor"

}


pkg_postinst() {
echo "----- BEGIN LICENSE -----"
echo "Andrew Weber"
echo "Single User License"
echo "EA7E-855605"
echo "813A03DD 5E4AD9E6 6C0EEB94 BC99798F"
echo "942194A6 02396E98 E62C9979 4BB979FE"
echo "91424C9D A45400BF F6747D88 2FB88078"
echo "90F5CC94 1CDC92DC 8457107A F151657B"
echo "1D22E383 A997F016 42397640 33F41CFC"
echo "E1D0AE85 A0BBD039 0E9C8D55 E1B89D5D"
echo "5CDB7036 E56DE1C0 EFCC0840 650CD3A6"
echo "B98FC99C 8FAC73EE D2B95564 DF450523"
echo "------ END LICENSE ------"
}
