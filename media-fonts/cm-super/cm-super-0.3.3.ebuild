# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="Computer Modern Type1 fonts in many encodings"
HOMEPAGE="http://www.ctan.org/info?id=cm-super" # may state wrong version
SRC_URI="ftp://tug.ctan.org/pub/tex-archive/fonts/ps-type1/${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="afm"

DEPEND=""
RDEPEND=">=app-text/tetex-3"

S=${WORKDIR}/${PN}

SUPPLIER="public"
CONFIG_PROTECT_MASK="/etc/texmf/texmf.d /etc/texmf/fmtutil.d /etc/texmf/updmap.d"

src_unpack() {
	unpack ${A}
	if use afm; then
		cd ${S}/afm
		gunzip *.gz
	fi
}

src_compile() {
	cd ${S}/dvips
	echo "" > updmap.cfg
	echo "# ${PF}" >> updmap.cfg
	for MAP in *.map; do
		echo "Map ${MAP}"
	done >> updmap.cfg
	echo "" >> updmap.cfg
}

src_install() {

	cd ${S}/pfb
	latex-package_src_doinstall pfb

	if use afm; then
		cd ${S}/afm
		latex-package_src_doinstall afm
	fi

	cd ${S}
	latex-package_src_doinstall sty

	dodoc COPYING ChangeLog FAQ INSTALL README TODO \
		|| einfo "Installing the documentation failed."

	insinto ${TEXMF}/fonts/enc/dvips/${PN}/
	doins dvips/*.enc dvips/config.cm-super \
		|| die "Inserting dvips fontencs failed."
		
	insinto ${TEXMF}/fonts/map/dvips/${PN}/	
	doins dvips/*.map  \
		|| die "Inserting dvips fontmaps failed."
		
	insinto /etc/texmf/updmap.d/
	newins dvips/updmap.cfg 20cm-super.cfg \
		|| die "Inserting font map list failed."

	# Stuff we don't install:
	# * dvips/cm-super.GS        (do we need this? Where to put it?)
	# * debian/                  (debian specific information)
	# * inf/cm-super-inf.tar.bz2 (list of <fontname>.inf files)
	# * vtex/                    (map files for vtex)
}
