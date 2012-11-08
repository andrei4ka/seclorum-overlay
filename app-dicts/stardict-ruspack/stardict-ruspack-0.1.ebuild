DESCRIPTION="Collection of dicts for stardict."
HOMEPAGE="http://gnome.msiu.ru/stardict.php"
SRC_URI="ftp://ftp.msiu.ru/education/FSF-Windows/stardict/dicts/stardict-dicts.exe"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=app-dicts/stardict-2.4.2"

DEPEND="${RDEPEND}
app-arch/unrar"

src_install() {
mkdir -p ${D}/usr/share/stardict/dic
unrar e ${DISTDIR}/stardict-dicts.exe ${D}/usr/share/stardict/dic/
}