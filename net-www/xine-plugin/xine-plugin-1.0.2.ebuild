# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit nsplugins

DESCRIPTION="A media plugin for Mozilla browsers and Opera."
HOMEPAGE="http://xinehq.de"
SRC_URI="mirror://sourceforge/xine/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X"

DEPEND=">=media-libs/xine-lib-1.0
		|| ( www-client/mozilla-firefox
			www-client/seamonkey 
			www-client/opera )"

RDEPEND="${DEPEND}"

INSTALL_DIR="/opt/netscape/plugins"

src_compile() {
	econf $(use_with X) --with-plugindir=${D}/${INSTALL_DIR} \
			|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install || die "install failed"
	inst_plugin ${INSTALL_DIR}/xineplugin.la
	inst_plugin ${INSTALL_DIR}/xineplugin.so

	dodoc AUTHORS NEWS README ChangeLog
}
