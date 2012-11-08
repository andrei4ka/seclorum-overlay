inherit qt4 git

EGIT_REPO_URI="git://git.altlinux.org/people/cas/packages/cuneiform-qt.git"

DESCRIPTION="Qt interface for Cuneiform"
HOMEPAGE="http://www.altlinux.org/Cuneiform-Qt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Насчёт минимальной версии Qt не уверен
DEPEND=">=x11-libs/qt-4.5"
RDEPEND="${DEPEND}"

src_compile () {
	cd "${S}/cuneiform-qt"
	sed 's/\/share\/apps\/cuneiform-qt\//\/share\/cuneiform-qt\//' -i cuneiform-qt.pro
	PREFIX="/usr" eqmake4
	emake
}

src_install() {
	cd "${S}/cuneiform-qt"
	dodoc AUTHORS README TODO
	INSTALL_ROOT="${D}" emake DESTDIR="${D}" install
}

