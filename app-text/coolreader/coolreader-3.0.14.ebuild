# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WX_GTK_VER="2.8"

inherit eutils

MY_P_ARCH="cr_${PV}"
MY_P="cr-${PV}"
HYP_ARCH="AlReader2.Hyphen.zip"

DESCRIPTION="CoolReader - reader of fictionbook texts"
HOMEPAGE="http://www.coolreader.org/"
SRC_URI="mirror://sourceforge/crengine/${MY_P_ARCH}-0ubuntu1.tar.gz
		hyphen? ( http://alreader.kms.ru/AlReader/${HYP_ARCH} )"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hyphen"

DEPEND="x11-libs/wxGTK
	app-arch/unzip"
RDEPEND="media-fonts/corefonts"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	use hyphen && unpack ${HYP_ARCH}
}

src_prepare() {
	eautoreconf
	# fix for amd64
	if use amd64; then
		sed -e 's/unsigned int/unsigned long/g' -i crengine/src/lvdocview.cpp \
		|| die "sed lvdocview.cpp failed"
	fi
}

src_configure() {
	cd ${S}
	sh macros/autogen.sh
	local myconf=" --prefix=/usr"
	econf ${myconf} || die "No configure!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	if use hyphen; then
		cd ${WORKDIR}
		insinto /usr/share/crengine
		find . -name "*hyphen*pdb" -exec \
			doins {} \;
	fi
	dosym ../fonts/corefonts /usr/share/crengine/fonts
	dodoc AUTHORS README
}
