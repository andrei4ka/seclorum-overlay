inherit font

DESCRIPTION="Computer Modern unicode OpenType fonts"
HOMEPAGE="http://canopus.iacp.dvo.ru/~panov/cm-unicode/"
LICENSE="X11"
SRC_URI="mirror://sourceforge/${PN}/${P}-otf.tar.gz
ftp://canopus.iacp.dvo.ru/pub/Font/${PN}/${P}-otf.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS="Changes FAQ README TODO"
FONT_SUFFIX="otf"
RESTRICT="mirror strip binchecks"
