# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-mod

DESCRIPTION="A memory analysis tool for Linux"
HOMEPAGE="http://www.berthels.co.uk/exmap/"
SRC_URI="http://www.berthels.co.uk/exmap/download/${P}.tgz"
IUSE="X debug"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-libs/libpcre
	X? ( >=dev-cpp/gtkmm-2.4 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-libs/boost"

MODULE_NAMES="exmap(misc:${S}/kernel)"
BUILD_TARGETS="clean kernel_modules"

src_prepare() {
	# patch find_task_by_pid to pid_task and &proc_root to NULL
	epatch ${FILESDIR}/${P}-kernel.patch

	# use $(MAKE), replaces -gmake.patch
	# remove forced CXXFLAGS -g, replaces -nodebug.patch
	# clean up CXX/LD invocations, replaces -no_libs_on_ldflags.patch
	epatch ${FILESDIR}/${P}-makefiles.patch
	
	# somthing strange between linux-mod supplied ARCH and old kernels
	# which leads to arc/x86/Makefile: file/dir x86 not found
	if kernel_is -lt 2 6 25 ; then 
		sed -i "s:\$(MAKE):unset ARCH ; \$(MAKE):" kernel/Makefile || die
	fi

	# new gcc include behavior
	epatch ${FILESDIR}/${P}-gcc.patch
	
	if use amd64 ; then
		## avoid application crash on unexpected calculation error
		#epatch ${FILESDIR}/${P}-hack.patch

		# random 64bit stuff from http://www.kdedevelopers.org/node/4166
		epatch ${FILESDIR}/${P}-fix64bit.patch
	
		rm -v src/fc4-libc-2.3.5.so src/fc4-libnss_files-2.3.5.so src/munged-ls-threeloads src/prelinked-amule
	fi
}

src_compile() {
	export KERNEL_DIR
	linux-mod_src_compile

	if use debug ; then
		CXXFLAGS="${CXXFLAGS} -g"
	fi
	emake CXX="$(tc-getCXX)" LD="$(tc-getLD)" -C jutil || die
	if ! use X ; then
		myBT="exmtool"
	fi
	emake CXX="$(tc-getCXX)" LD="$(tc-getLD)" -C src $myBT || die
}

src_install() {
	linux-mod_src_install

	dobin src/exmtool || die
	if use X ; then
		dobin src/gexmap || die
	fi
	dodoc TODO README || die
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "Now load the exmap kernel module by running:"
	elog "  # modprobe exmap"
	
}
