# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils


MY_NAME="WikidPad"
MY_PV=${PV/_/}
 
DESCRIPTION="Wiki-like notebook for storing your thoughts, ideas, todo lists, contacts, or anything else you can think of to write down."
HOMEPAGE="http://groups.google.com/group/wikidpad/"


SRC_URI="http://groups.google.com/group/wikidpad/web/${MY_NAME}-${MY_PV}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S=${WORKDIR}

INSTALL_DIR="/opt/${PN}"

src_install() {
	dodir ${INSTALL_DIR}
	cp -R ${S}/* ${D}/${INSTALL_DIR}/ || die "Install failed!"
	
	cat > wikidpad <<-EOF
		#!/bin/bash
		export PYTHONPATH=\${PYTHONPATH}:${INSTALL_DIR}/lib/
		python ${INSTALL_DIR}/WikidPad.py
	EOF
	
	exeinto ${INSTALL_DIR}
    	doexe wikidpad
}
