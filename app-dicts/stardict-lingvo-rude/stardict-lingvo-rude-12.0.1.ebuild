# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils versionator
MY_PV1=${PV%.*.*}

DESCRIPTION="Collection of Lingvo dicts for stardict. Russian to Deutsch"
HOMEPAGE="http://seclorum.msk.ru"

SRC_URI="
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_AutoService.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Auto.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Banks.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Beer.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Economics.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Food.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Law.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Medical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Polytechnical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_DE_Universal.tar.gz
"
LICENSE="Lingvo"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+AutoService +Auto +Banks +Beer +Economics +Food +Law +Medical +Polytechnical +Universal"

RDEPEND=">=app-dicts/stardict-2.4.2"

DEPEND="${RDEPEND}"

src_install() {
	mkdir -p ${D}/usr/share/stardict/dic
	
	if use AutoService; then
		cp -R ${WORKDIR}/AutoServiceRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Auto; then
		cp -R ${WORKDIR}/AutoRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Banks; then
		cp -R ${WORKDIR}/BanksRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Beer; then
		cp -R ${WORKDIR}/BeerRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Economics; then
		cp -R ${WORKDIR}/EconomicsRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Food; then
		cp -R ${WORKDIR}/FoodRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Law; then
		cp -R ${WORKDIR}/LawRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Medical; then
		cp -R ${WORKDIR}/MedicalRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Polytechnical; then
		cp -R ${WORKDIR}/PolytechnicalRuDe.* ${D}/usr/share/stardict/dic/
	fi

	if use Universal; then
		cp -R ${WORKDIR}/UniversalRuDe.* ${D}/usr/share/stardict/dic/
	fi
}