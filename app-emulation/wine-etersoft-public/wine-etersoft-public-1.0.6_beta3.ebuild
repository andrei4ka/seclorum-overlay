# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic multilib

DESCRIPTION="MS Windows compatibility layer (WINE@Etersoft public edition)"
HOMEPAGE="http://etersoft.ru/wine"
# FIXME: any better way?
WINEVER=20070302
WINENUMVERSION="1.0.6"
SRC_URI="ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft-$WINENUMVERSION/sources/tarball/wine-$WINEVER.tar.bz2
	 ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft-$WINENUMVERSION/sources/tarball/wine-etersoft-public-$WINEVER.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="alsa arts cups dbus esd hal jack jpeg lcms ldap nas ncurses opengl oss scanner xml X"
RESTRICT="test" #72375

RDEPEND=">=media-libs/freetype-2.0.0
	media-fonts/corefonts
	ncurses? ( >=sys-libs/ncurses-5.2 )
	jack? ( media-sound/jack-audio-connection-kit )
	dbus? ( sys-apps/dbus )
	hal? ( sys-apps/hal )
	X? (
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
		x11-apps/xmessage

	)
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	cups? ( net-print/cups )
	opengl? ( virtual/opengl )
	jpeg? ( media-libs/jpeg )
	ldap? ( net-nds/openldap )
	lcms? ( media-libs/lcms )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	>=media-gfx/fontforge-20060703
	scanner? ( media-gfx/sane-backends )
	amd64? (
		>=app-emulation/emul-linux-x86-xlibs-2.1
		>=app-emulation/emul-linux-x86-soundlibs-2.1
		>=sys-kernel/linux-headers-2.6
	)"
DEPEND="${RDEPEND}
	!app-emulation/wine
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto
	sys-devel/bison
	sys-devel/flex"

export ABI=x86

src_unpack() {
	unpack wine-$WINEVER.tar.bz2
	unpack wine-etersoft-public-$WINEVER.tar.bz2
	cd "${WORKDIR}"/wine-$WINEVER/ || die
	epatch etersoft/wine-etersoft.patch
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
	
}

config_cache() {
	local h ans="no"
	use $1 && ans="yes"
	shift
	for h in "$@" ; do
		[[ ${h} == *.h ]] \
			&& h=header_${h} \
			|| h=lib_${h}
		export ac_cv_${h//[:\/.]/_}=${ans}
	done
}

src_compile() {
	export LDCONFIG=/bin/true
	use arts    || export ac_cv_path_ARTSCCONFIG=""
	use esd     || export ac_cv_path_ESDCONFIG=""
	use scanner || export ac_cv_path_sane_devel="no"
	config_cache jack jack/jack.h
	config_cache cups cups/cups.h
	config_cache alsa alsa/asoundlib.h sys/asoundlib.h asound:snd_pcm_open
	config_cache nas audio/audiolib.h audio/soundlib.h
	config_cache xml libxml/parser.h libxslt/pattern.h libxslt/transform.h
	config_cache ldap ldap.h lber.h
	config_cache dbus dbus/dbus.h
	config_cache hal hal/libhal.h
	config_cache jpeg jpeglib.h
	config_cache oss sys/soundcard.h machine/soundcard.h soundcard.h
	config_cache lcms lcms.h
	use x86 && config_cache truetype freetype:FT_Init_FreeType

	strip-flags

	cd "${WORKDIR}"/wine-$WINEVER/
	econf \
		CC=$(tc-getCC) \
		--sysconfdir=/etc/wine \
		--enable-opengl \
		--with-x \
		$(use_enable debug trace) \
		$(use_enable debug) \
		|| die "configure failed"

	emake -j1 depend || die "depend"
	emake all || die "all"
}

src_install() {
	cd "${WORKDIR}"/wine-$WINEVER/
	make DESTDIR="${D}" install || die
        mv "${D}"/usr/bin/wine "${D}"/usr/bin/wine-glibc
	make -C etersoft install prefix=${D}/usr initdir=${D}/etc/init.d sysconfdir=${D}/etc
	
	rm -f "${D}"/usr/bin/wineprefixcreate
	ln -s wine "${D}"/usr/bin/wineprefixcreate

	mkdir -p "${D}"/usr/share/wine/fonts 
	cp "${WORKDIR}"/wine-$WINEVER/fonts/prebuild/*.ttf "${D}"/usr/share/wine/fonts/
	cp "${WORKDIR}"/wine-$WINEVER/fonts/prebuild/*.fon "${D}"/usr/share/wine/fonts/
	cp "${WORKDIR}"/wine-$WINEVER/etersoft/menu.directory "${D}"/usr/share/wine/
}

pkg_postinst() {
	einfo ""
	einfo "For configuration use winecfg"
	einfo ""
}