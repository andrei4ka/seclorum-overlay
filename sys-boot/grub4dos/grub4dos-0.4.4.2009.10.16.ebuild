# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/grub/grub-0.97-r9.ebuild,v 1.5 2009/07/04 18:46:05 robbat2 Exp $

# XXX: we need to review menu.lst vs grub.conf handling.  We've been converting
#      all systems to grub.conf (and symlinking menu.lst to grub.conf), but
#      we never updated any of the source code (it still all wants menu.lst),
#      and there is no indication that upstream is making the transition.

inherit mount-boot eutils flag-o-matic toolchain-funcs autotools linux-info versionator
#2009-10-16

MY_PV1=$(get_version_component_range 1-3)
MY_PV1=${MY_PV1%/./-}
MY_PV2=$(replace_all_version_separators - $(get_version_component_range 4-6))


DESCRIPTION="GRU4DOS boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
SRC_URI="http://nufans.net/grub4dos/${PN}-${MY_PV1}-${MY_PV2}-src.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="custom-cflags ncurses netboot static"

DEPEND="ncurses? (
		>=sys-libs/ncurses-5.2-r5
	)"
PROVIDE="virtual/bootloader"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/grub4dos* ${WORKDIR}/${P}
	cd "${S}"
	epatch ${FILESDIR}/060_all_grub-0.96-netboot-pic.patch
}

src_compile() {
	filter-flags -fPIE #168834


	unset BLOCK_SIZE #73499

	### i686-specific code in the boot loader is a bad idea; disabling to ensure
	### at least some compatibility if the hard drive is moved to an older or
	### incompatible system.

	# grub-0.95 added -fno-stack-protector detection, to disable ssp for stage2,
	# but the objcopy's (faulty) test fails if -fstack-protector is default.
	# create a cache telling configure that objcopy is ok, and add -C to econf
	# to make use of the cache.
	#
	# CFLAGS has to be undefined running econf, else -fno-stack-protector detection fails.
	# STAGE2_CFLAGS is not allowed to be used on emake command-line, it overwrites
	# -fno-stack-protector detected by configure, removed from netboot's emake.
	use custom-cflags || unset CFLAGS

	export grub_cv_prog_objcopy_absolute=yes #79734


	# build the net-bootable grub first, but only if "netboot" is set
	if use netboot ; then
		econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		--enable-diskless \
		--enable-{tulip,via-rhine} || die "netboot econf failed"

		emake || die "making netboot stuff"

		mv -f stage2/{nbgrub,pxegrub} "${S}"/
		mv -f stage2/stage2 stage2/stage2.netboot

		make clean || die "make clean failed"
	fi

	# Now build the regular grub
	# Note that FFS and UFS2 support are broken for now - stage1_5 files too big
	econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		$(use_with ncurses curses) \
		|| die "econf failed"

	# sanity check due to common failure
	use ncurses && ! grep -qs "HAVE_LIBCURSES.*1" config.h && die "USE=ncurses but curses not found"

	emake || die "making regular stuff"
}


src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample
	dodoc "${FILESDIR}"/grub.conf.gentoo
	prepalldocs

	insinto /usr/share/grub
	doins "${DISTDIR}"/splash.xpm.gz
}

setup_boot_dir() {
	local boot_dir=$1
	local dir=${boot_dir}

	mkdir -p "${dir}"
	[[ ! -L ${dir}/boot ]] && ln -s . "${dir}/boot"
	dir="${dir}/grub"
	if [[ ! -e ${dir} ]] ; then
		mkdir "${dir}" || die "${dir} does not exist!"
	fi

	# change menu.lst to grub.conf
	if [[ ! -e ${dir}/grub.conf ]] && [[ -e ${dir}/menu.lst ]] ; then
		mv -f "${dir}"/menu.lst "${dir}"/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi

	if [[ ! -e ${dir}/menu.lst ]]; then
		einfo "Linking from new grub.conf name to menu.lst"
		ln -snf grub.conf "${dir}"/menu.lst
	fi

	if [[ -e ${dir}/stage2 ]] ; then
		mv "${dir}"/stage2{,.old}
		ewarn "*** IMPORTANT NOTE: you must run grub and install"
		ewarn "the new version's stage1 to your MBR.  Until you do,"
		ewarn "stage1 and stage2 will still be the old version, but"
		ewarn "later stages will be the new version, which could"
		ewarn "cause problems such as an unbootable system."
		ewarn "This means you must use either grub-install or perform"
		ewarn "root/setup manually! For more help, see the handbook:"
		ewarn "http://www.gentoo.org/doc/en/handbook/handbook-${ARCH}.xml?part=1&chap=10#grub-install-auto"
		ebeep
	fi

	einfo "Copying files from /lib/grub, /usr/lib/grub and /usr/share/grub to ${dir}"
	for x in \
		"${ROOT}"/lib*/grub/*/* \
		"${ROOT}"/usr/lib*/grub/*/* \
		"${ROOT}"/usr/share/grub/* ; do
		[[ -f ${x} ]] && cp -p "${x}" "${dir}"/
	done

	if [[ ! -e ${dir}/grub.conf ]] ; then
		s="${ROOT}/usr/share/doc/${PF}/grub.conf.gentoo"
		[[ -e "${s}" ]] && cat "${s}" >${dir}/grub.conf
		[[ -e "${s}.gz" ]] && zcat "${s}.gz" >${dir}/grub.conf
		[[ -e "${s}.bz2" ]] && bzcat "${s}.bz2" >${dir}/grub.conf
	fi

	# Per bug 218599, we support grub.conf.install for users that want to run a
	# specific set of Grub setup commands rather than the default ones.
	grub_config=${dir}/grub.conf.install
	[[ -e ${grub_config} ]] || grub_config=${dir}/grub.conf
	if [[ -e ${grub_config} ]] ; then
		egrep \
			-v '^[[:space:]]*(#|$|default|fallback|initrd|password|splashimage|timeout|title)' \
			"${grub_config}" | \
		/sbin/grub --batch \
			--device-map="${dir}"/device.map \
			> /dev/null
	fi

	# the grub default commands silently piss themselves if
	# the default file does not exist ahead of time
	if [[ ! -e ${dir}/default ]] ; then
		grub-set-default --root-directory="${boot_dir}" default
	fi
	einfo "Grub has been installed to ${boot_dir} successfully."
}

pkg_postinst() {
	if [[ -n ${DONT_MOUNT_BOOT} ]]; then
		elog "WARNING: you have DONT_MOUNT_BOOT in effect, so you must apply"
		elog "the following instructions for your /boot!"
		elog "Neglecting to do so may cause your system to fail to boot!"
		elog
	else
		setup_boot_dir "${ROOT}"/boot
		# Trailing output because if this is run from pkg_postinst, it gets mixed into
		# the other output.
		einfo ""
	fi
	elog "To interactively install grub files to another device such as a USB"
	elog "stick, just run the following and specify the directory as prompted:"
	elog "   emerge --config =${PF}"
	elog "Alternately, you can export GRUB_ALT_INSTALLDIR=/path/to/use to tell"
	elog "grub where to install in a non-interactive way."

}

pkg_config() {
	local dir
	if [ ! -d "${GRUB_ALT_INSTALLDIR}" ]; then
		einfo "Enter the directory where you want to setup grub:"
		read dir
	else
		dir="${GRUB_ALT_INSTALLDIR}"
	fi
	setup_boot_dir "${dir}"
}
