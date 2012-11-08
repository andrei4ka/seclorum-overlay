# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator
MY_PV=${PV//./_}
VNC_RELEASE="41964"

X86_PACKAGE="vnc-E${MY_PV}-x86_linux"
AMD64_PACKAGE="vnc-E${MY_PV}-x64_linux"


DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.realvnc.com/"
SRC_URI="x86? ( ftp://seclorum.ru/etc/gentoo/portage/distfiles/${X86_PACKAGE}.tar.gz )
	 amd64? ( ftp://seclorum.ru/etc/gentoo/portage/distfiles/${AMD64_PACKAGE}.tar.gz )"

LICENSE="RealVNC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client server x-extension java"
#RESTRICT="fetch"

RDEPEND="sys-libs/zlib
	media-libs/freetype
	x11-libs/libSM
	x11-libs/libXtst
	server? (
		x11-libs/libXi
		x11-libs/libXfont
		x11-libs/libXmu
		x11-libs/libxkbfile
		x11-libs/libXrender
		x11-apps/xauth
		x11-apps/xsetroot
	)
	java? (	virtual/jdk )
	!net-misc/tightvnc
	!net-misc/vnc
	"

if use x86; then
	PACKAGE="${X86_PACKAGE}"
	PACKAGE_RELEASE="vnc-E${MY_PV}-x86_linux"
elif use amd64; then
	PACKAGE="${AMD64_PACKAGE}"
	PACKAGE_RELEASE="vnc-E${MY_PV}-x64_linux"
fi

S=${WORKDIR}/${PACKAGE_RELEASE}
INSTALLDIR=/opt/${PACKAGE}

pkg_setup() {
	local varsnum varstypes="client server x-extension" varstype
	declare -i varsnum=0
	for varstype in ${varstypes}; do
		useq ${varstype} && let varsnum++
	done

	if [ ${varsnum} -lt 1 ]; then
		eerror
		eerror "Select one or more USE-flag out of these: ${varstypes}"
		eerror
		die "No one use-flag selected"
	fi
}


pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit http://www.realvnc.com/cgi-bin/download.cgi?product=enterprise4/Xvnc"
	einfo " 2. Give your details"
	einfo " 3. Download ${PACKAGE}.tar.gz"
	einfo " 4. Move the file to ${DISTDIR}"
	einfo
}


src_install() {
	rm -f ${S}/vncinstall
	dodir ${INSTALLDIR} || die

	if use server ; then
		for f in vncconfig vncinitconfig vnckeygen vnclicense vncpasswd vncserver x0vncserver Xvnc; do
			cp ${S}/$f ${D}${INSTALLDIR} || die
			mv $f.man $f.1
			doman $f.1
		done
	fi

	if use x-extension && ! use server; then
		for f in vncconfig vnckeygen vnclicense vncpasswd ; do
			cp ${S}/$f ${D}${INSTALLDIR} || die
			mv $f.man $f.1
			doman $f.1
		done
		insinto /usr/$(get_libdir)/xorg/modules/extensions/
		doins ${S}/vnc.so || die
	elif use x-extension && use server ; then 
		insinto /usr/$(get_libdir)/xorg/modules/extensions/
		doins ${S}/vnc.so || die
	fi

	if use client ; then
		for f in vncviewer vncaddrbook; do
			cp ${S}/$f ${D}${INSTALLDIR} || die
			mv $f.man $f.1
			doman $f.1
		done

		doicon ${FILESDIR}/vncviewer.png
		
		cat > vncviewer.desktop <<-EOF
			[Desktop Entry]
			Encoding=UTF-8
			Name=VNCviewer
			Comment=VNCviewer
			Icon=vncviewer
			Exec=vncviewer
			Terminal=false
			Type=Application
			Categories=Network;
		EOF

		cat > vncaddrbook.desktop <<-EOF
			[Desktop Entry]
			Encoding=UTF-8
			Name=VNCAddrbook
			Comment=VNCAddrbook
			Icon=vncviewer
			Exec=${INSTALLDIR}/vncaddrbook
			Terminal=false
			Type=Application
			Categories=Network;
		EOF
		
		insinto /usr/share/applications/
		doins vncviewer.desktop

		insinto /usr/share/applications/
		doins vncaddrbook.desktop

		dosym ${INSTALLDIR}/vncviewer /usr/bin/vncviewer
	fi

	if use java ; then
		dodir ${INSTALLDIR}/java
		cp -r java ${INSTALLDIR}/java || die
	fi

	dodir /etc/env.d || die

	echo "PATH=\"${INSTALLDIR}\"" >> ${D}/etc/env.d/99${PN} || die

	dodoc README
}

pkg_postinst() {
	einfo "RealVNC has been installed."

	if use x-extension; then
		einfo "To run X-server with vnc-modulle (for example):"
		einfo "1. Set password by \"vncpasswd /etc/vncpasswd"\"
		einfo "2. Add follow lines in /etc/X11/xorg.conf"
		einfo "    in Section \"Module\""
		einfo "       Load  \"vnc\""
		einfo "    in Section \"Screen\""
		einfo "       Option  \"SecurityTypes\" \"VncAuth\""
		einfo "       Option  \"UserPasswdVerifier\" \"VncAuth\""
		einfo "       Option  \"PasswordFile\" \"/etc/vncpasswd\""
		einfo "3. Restart X-server"
		einfo ""
	fi

	einfo "To register RealVNC run ${INSTALLDIR}/vnclicense"
}
