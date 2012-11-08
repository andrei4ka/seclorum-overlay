# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils versionator
MY_PV1=${PV%.*.*}

DESCRIPTION="Collection of Lingvo dicts for stardict. Deutsch to Russian"
HOMEPAGE="http://seclorum.msk.ru"

SRC_URI="
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Austria.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_AutoService.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Banks.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Chemistry.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Economics.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Food.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Idioms.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Law.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Medical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Polytechnical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_DE_RU_Universal.tar.gz
"

LICENSE="Lingvo"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+Austria +AutoService +Banks +Chemistry +Economics +Food +Idioms +Law +Medical +Polytechnical +Universal"

RDEPEND=">=app-dicts/stardict-2.4.2"

DEPEND="${RDEPEND}"

src_install() {
	mkdir -p ${D}/usr/share/stardict/dic
	
	if use Austria; then
		cp -R ${WORKDIR}/AustriaDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use AutoService; then
		cp -R ${WORKDIR}/AutoServiceDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Banks; then
		cp -R ${WORKDIR}/BanksDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Chemistry; then
		cp -R ${WORKDIR}/ChemistryDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Economics; then
		cp -R ${WORKDIR}/EconomicsDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Food; then
		cp -R ${WORKDIR}/FoodDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Idioms; then
		cp -R ${WORKDIR}/IdiomsDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Law; then
		cp -R ${WORKDIR}/LawDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Medical; then
		cp -R ${WORKDIR}/MedicalDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Polytechnical; then
		cp -R ${WORKDIR}/PolytechnicalDeRu.* ${D}/usr/share/stardict/dic/
	fi

	if use Universal; then
		cp -R ${WORKDIR}/UniversalDeRu.* ${D}/usr/share/stardict/dic/
	fi
}