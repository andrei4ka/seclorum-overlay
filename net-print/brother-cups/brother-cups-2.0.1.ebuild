# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

LPR_BASEURI="http://solutions.brother.com/Library/sol/printer/linux/rpmfiles/lpr_others"
CUPS_BASEURI="http://solutions.brother.com/Library/sol/printer/linux/rpmfiles/cups_wrapper"

inherit rpm eutils

KEYWORDS="~amd64 ~x86"


DESCRIPTION="Brother CUPS printer driver."
HOMEPAGE="http://solutions.brother.com/linux/en_us/index.html"
SRC_URI=" brother_printers_DCP_8065DN? ( ${LPR_BASEURI}/brdcp8065dnlpr-${PV}-1.i386.rpm ${CUPS_BASEURI}/cupswrapperDCP8065DN-${PV}-1.i386.rpm )
	  brother_printers_MFC_8860DN? ( ${LPR_BASEURI}/brmfc8860dnlpr-${PV}-1.i386.rpm ${CUPS_BASEURI}/cupswrapperMFC8860DN-${PV}-1.i386.rpm )
	
"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
IUSE_BROTHER_PRINTERS="DCP_8065DN MFC_8860DN "

for IUSE_BROTHER_PRINTER in ${IUSE_BROTHER_PRINTERS}; do
	IUSE="${IUSE} brother_printers_${IUSE_BROTHER_PRINTER/-/_}"
done

DEPEND=""
RDEPEND=">=net-print/cups-1.3"


src_unpack() {
	rpm_src_unpack
}

src_compile() {
  for BROTHER_PRINTER in ${IUSE_BROTHER_PRINTERS}; do
    if use brother_printers_${BROTHER_PRINTER/-/_}; then
      BR_NAME=${BROTHER_PRINTER/_/}
      echo ${BR_NAME}
      sed -e "s|/usr/lib/cups/|/usr/libexec/cups/|g" -i usr/local/Brother/cupswrapper/cupswrapper${BR_NAME}-${PV}
      sed -e "s|/usr/lib64/cups/|/usr/libexec/cups/|g" -i usr/local/Brother/cupswrapper/cupswrapper${BR_NAME}-${PV}
    fi
  done

}

src_install() {
	cp -Rf "./" "${D}/"
}

pkg_postinst() {
  for BROTHER_PRINTER in ${IUSE_BROTHER_PRINTERS}; do
    if use brother_printers_${BROTHER_PRINTER/-/_}; then
      BR_NAME=${BROTHER_PRINTER/_/}
	${ROOT}usr/local/Brother/inf/setupPrintcap ${BR_NAME} -i USB
	${ROOT}usr/local/Brother/inf/braddprinter -i ${BR_NAME}
	echo "[psconvert2]" >> ${ROOT}usr/local/Brother/inf/br${BR_NAME}func
	echo "pstops=`which pstops`" >> ${ROOT}usr/local/Brother/inf/br${BR_NAME}func

	${ROOT}usr/local/Brother/cupswrapper/cupswrapper${BR_NAME}-${PV} -i
    fi
  done
}
