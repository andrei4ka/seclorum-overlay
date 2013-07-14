# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator
MY_PV=${PV//./_}

X86_PACKAGE="vnc-E${MY_PV}-x86_linux"
AMD64_PACKAGE="vnc-E${MY_PV}-x64_linux"


DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.realvnc.com/"
SRC_URI="x86? ( VNC-${PV}-Linux-x86-ANY.tar.gz )
	 amd64? ( VNC-${PV}-Linux-x64-ANY.tar.gz )"

LICENSE="RealVNC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client server x-extension java cups"
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
	PACKAGE_RELEASE="VNC-${PV}-Linux-x86"
elif use amd64; then
	PACKAGE_RELEASE="VNC-${PV}-Linux-x64"
fi

S=${WORKDIR}/${PACKAGE_RELEASE}
INSTALLDIR=/opt/${PN}

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

	for f in vncviewer vncaddrbook vncserver-x11 vncserver-x11-core Xvnc Xvnc-core \
         vncserverui vncserver-virtual vncserver-virtuald \
         vncserver-x11-serviced vncpasswd vnclicense vnclicensewiz \
         vncpipehelper vncchat vncinitconfig; do
	
	  dobin ${f}
	  
	  if [ -f $f.man ]; then
	    mv ${f}.man ${f}.1
	    doman ${f}.1
	  fi
	
	 done
	mkdir -p "${D}"/usr/$(get_libdir)/vnc
	for f in get_primary_ip4 vncelevate; do
	  insinto /usr/$(get_libdir)/vnc
	  doins $f
	done

	mkdir -p "${D}"/usr/share/vnc/fonts
	insinto /usr/share/vnc/fonts
	doins fonts/*

	fperms 4555 /usr/bin/vncserver-x11
	fperms 4555 /usr/bin/Xvnc

	doinitd "${FILESDIR}"/vncserver-virtuald
	doinitd "${FILESDIR}"/vncserver-x11-serviced

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
			Exec=vncaddrbook
			Terminal=false
			Type=Application
			Categories=Network;
		EOF
		
		insinto /usr/share/applications/
		doins vncviewer.desktop

		insinto /usr/share/applications/
		doins vncaddrbook.desktop

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

	einfo "To register RealVNC run vnclicense -add 69ZYC-5SN2T-UZAFL-BNW6D-LQ73A"
	einfo "Or user another sn: 5S4U9-Z57P9-8U37F-BNPUK-C9MZA"
	einfo "73Z5P-HPNEA-26D3W-V3YRK-3HF5A"
	einfo "86JCG-UQK7X-26F3P-KR28T-S9N7A"
}
