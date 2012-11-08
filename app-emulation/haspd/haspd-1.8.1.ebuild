# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic

DESCRIPTION="HASP daemon for access to parallel and usb keys"
HOMEPAGE="http://www.aladdin.com"
SRC_URI="ftp://ftp.aladdin.com/pub/aladdin.de/hardlock/linux/v1.7/HDD_Linux_dinst.tar.gz
	net_hasp? ( ftp://ftp.aladdin.com/pub/hasp/hl/linux/hasplm_linux_8.30.tgz
	ftp://ftp.aladdin.com/pub/hasp/hl/linux/WineHASP.zip )"
LICENSE="Proprietary"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="net_hasp"

RDEPEND=">=app-emulation/hasp-par-1.7"
DEPEND="${RDEPEND}"

pkg_preinst() {
    if [ ! -f /proc/bus/usb/devices ]; then
        eerror "Check kernel for CONFIG_USB_DEVICEFS... "
        if [ ! -d /proc/bus/usb ] ; then
                eerror "You have to use kernel with CONFIG_USB_DEVICEFS enabled"
                die "You have to mount usbfs (usbdevfs) filesystem into /proc/bus/usb, f.i.: mount -t usbfs none /proc/bus/usb"

        fi
    fi

}

src_unpack() {
	unpack HDD_Linux_dinst.tar.gz
	mv HDD_Linux_dinst hasp
	use net_hasp && {
	    unpack WineHASP.zip
	    mv WineHASP/linux/winehasp hasp/
	    mv WineHASP/linux/setwinehaspport.exe hasp/
	    cd hasp
	    unpack hasplm_linux_8.30.tgz
	}
}


src_install() {
	dodir "/usr/sbin"
	dodir "/etc/init.d"
	cd "${WORKDIR}"/hasp
	insinto /usr/bin
	doins hasplm
	doins winehasp
	doins setwinehaspport.exe
	fperms a+x /usr/bin/hasplm
	fperms a+x /usr/bin/winehasp
	fperms a+x /usr/bin/setwinehaspport.exe
	newinitd "${FILESDIR}"/hasplm.init hasplm
	newinitd "${FILESDIR}"/winehasp.init winehasp
	cp aksusbd "${D}"/usr/sbin/
	cp "${FILESDIR}"/haspd.init-1.8.1 "${D}"/etc/init.d/haspd
}
