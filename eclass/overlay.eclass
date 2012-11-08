# Distributed under the terms of the GNU General Public License, v2 or later
# Author Toffanin Mauro <toffanin.mauro@wiredtek.it>
# $Header: $
#inherit eutils

# show overlay warnings
overlay_pkg_setup() {

	echo
	einfo "This ebuild is provided from the \`${OVERLAY_NAME}\`"
	einfo "and is not part of the Gentoo portage."
	echo
	ewarn "The ebuilds that come from the \`${OVERLAY_NAME}\`"
	ewarn "are not always in perfect condition and may break things,"
	ewarn "so please use at your own risk and NEVER USE THEM in"
	ewarn "production unless YOU KNOW exactly WHAT ARE YOU DOING."
	echo
	einfo "If you do have troubles/problems with this ebuild,"
	einfo "please take it up with the ebuild provider and not"
	einfo "with the good people at Gentoo."
	echo
	ewarn "NEVER report bugs at http://bugs.gentoo.org"
	ewarn "please use the proper bugzilla:"
	ewarn
	ewarn "  ${OVERLAY_BUGZILLA}"
	ebeep 3
	echo
}

EXPORT_FUNCTIONS pkg_setup
