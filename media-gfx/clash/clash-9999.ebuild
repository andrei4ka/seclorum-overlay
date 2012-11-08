# this ugly ebuild made by AkhIL. akhilman at gmail dot com

EAPI=2

inherit eutils toolchain-funcs distutils qt4

KEYWORDS="~x86"

DESCRIPTION="Pencilanimation (fork Pencil)  is an opensource animation program initially designed to aid
character animators in efficently planning out a scene allowing quick timing
adjustments."
HOMEPAGE="http://geesas.sourceforge.net/clash/"

SRC_URI="http://geesas.svn.sourceforge.net/viewvc/geesas.tar.gz?view=tar -> geesas.tar.gz"

LICENSE="GPL"
SLOT="0"

DEPEND=">=media-libs/ming-0.4.0_beta5
		>=x11-libs/qt-4.2.3
		media-video/ffmpeg
		app-arch/p7zip
		"

		
S="${WORKDIR}/geesas/pencilanimation"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	cd "${S}"
	qmake Clash.pro
	emake || die "emake failed"
}

src_install() {
	newbin Clash clash
}

