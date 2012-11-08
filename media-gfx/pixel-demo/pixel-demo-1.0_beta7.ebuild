# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Pixel image editor"
HOMEPAGE="http://www.kanzelsberger.com/"
MY_PN="${PN/-/}"
MY_P="${MY_PN}-${PV}"
SRC_URI="x86? ( ${MY_P/_beta7/.699}-linux-nosetup.x86.tar.bz2 )
	amd64? ( ${MY_P/_beta7/.699}-linux.x86-64cmpt.tar.bz2 )"

LICENSE="pixel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cups dcraw lcms scanner spell openexr"
RESTRICT="fetch strip"

DEPEND="!media-gfx/pixel"

RDEPEND="media-libs/freetype
	media-libs/libpng
	media-libs/libsdl
	|| ( (
			x11-libs/libX11
			x11-libs/libXau
			x11-libs/libXdmcp
			x11-libs/libXext
		)
		virtual/x11
	)
	cups? ( net-print/cups )
	dcraw? ( media-gfx/dcraw )
	spellcheck? ( app-text/aspell )
	lcms? ( media-libs/lcms )
	scanner? ( media-gfx/sane-backends )
	openexr? ( media-libs/openexr )"

S=${WORKDIR}

pkg_nofetch() {
	echo
	einfo "Vendor has moved to session-based downloads, please visit:"
	ewarn "this ebuild is for build 699"
	ewarn "for x86 you need to download pixeldemo-1.0.699-linux-nosetup.x86.tar.bz2"
	ewarn "do NOT download pixeldemo-1.0.699-linux.x86.tar.gz since it is a binary installer"
	einfo "http://www.kanzelsberger.com/pixel/?page_id=4"
	einfo "to obtain binary package"
	einfo "place downloaded files in /usr/portage/distfiles"
	echo
}

src_install() {
	insinto /opt
	doins -r Pixel

	dodir /opt/bin
	dosym /opt/{Pixel,bin}/pixel
	fperms 755 /opt/Pixel/pixel

	dodir /usr/share/pixmaps
	dosym /opt/Pixel/pixel32.png /usr/share/pixmaps/pixel.png
	make_desktop_entry pixel Pixel pixel.png Graphics
}

pkg_postinst() {
	echo
	einfo "Upstream provides the following warning:"
	echo
	ewarn "If you're upgrading from older version it is recommended to delete"
	ewarn "configuration file from ~/.pixel/linux.ini as it might be missing "
	ewarn "new configuration entries."
	echo
}
