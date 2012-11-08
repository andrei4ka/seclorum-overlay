# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_VERSION="$(get_version_component_range 1-3)"
MY_BUILD="$(get_version_component_range 4-4)"

DESCRIPTION="Freeware advanced editor for dynamic and Web languages"
HOMEPAGE="http://www.activestate.com/products/komodo_edit/"
LICENSE="ActiveState Komodo Edit"

SRC_URI="http://downloads.activestate.com/Komodo/releases/${MY_VERSION}/Komodo-IDE-${MY_VERSION}-${MY_BUILD}-linux-libcpp6-x86.tar.gz"

SLOT="0"
KEYWORDS="~x86"

IUSE="default-templates"

DEPEND=">=media-libs/jpeg-6b
	virtual/libc"

RDEPEND="${DEPEND}"

S="${WORKDIR}/Komodo-IDE-${MY_VERSION}-${MY_BUILD}-linux-libcpp6-x86"

#QA_EXECSTACK_x86="opt/${PN}/lib/python/lib/python2.6/config/python.o"

#QA_TEXTRELS_x86="
#	opt/${PN}/lib/mozilla/components/libxpinstall.so
#	opt/${PN}/lib/mozilla/libxpcom_core.so
#	opt/${PN}/lib/mozilla/python/xpcom/_xpcom.so
#	opt/${PN}/lib/mozilla/python/komodo/SilverCity/_SilverCity.so
#	opt/${PN}/lib/mozilla/libxpcom_compat.so
#	opt/${PN}/lib/mozilla/plugins/libnpscimoz.so"
KOMODO_EDIT_INSTALLDIR="/opt/${PN}"
src_install() {
	dodir "${KOMODO_EDIT_INSTALLDIR}"
	
	"${S}/install.sh" \
		--install-dir "${D}/${KOMODO_EDIT_INSTALLDIR}" \
		--suppress-shortcut || die "original installer script failed"
	
	# Patches the Komodo launcher script, with the real base install dir.
	sed --in-place "s/^\INSTALLDIR=.*\$/INSTALLDIR=\"${KOMODO_EDIT_INSTALLDIR//\//\\/}\"/" "${D}/${KOMODO_EDIT_INSTALLDIR}/bin/komodo" || die "sed bin/komodo failed"

	dosym "${KOMODO_EDIT_INSTALLDIR}/bin/komodo" "/usr/bin/${PN}" || die "failed dosym Komodo launcher script"

	# Most default templates are empty, or near-empty, and can clutter
	# the new file dialog, so we permit not to install them.
	use default-templates || (
		rm -R "${D}/${KOMODO_EDIT_INSTALLDIR}/"lib/mozilla/extensions/*/templates/* &&
		rm -R "${D}/${KOMODO_EDIT_INSTALLDIR}/"lib/support/default-templates/* ||
			die "failed removing default templates"
	)

	for res in 16 32 48 128; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${KOMODO_EDIT_INSTALLDIR}/share/icons/komodo${res}.png ${PN}.png
	done

	make_desktop_entry \
		"${PN}" \
		"Komodo IDE" \
		"${PN}.png" \
		"Development;IDE;Editor;TextEditor" ||
			die "make_desktop_entry failed"
}
