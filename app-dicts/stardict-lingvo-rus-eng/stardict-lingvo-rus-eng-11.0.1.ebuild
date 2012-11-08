# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils versionator
MY_PV1=${PV%.*.*}

DESCRIPTION="Collection of Lingvo dicts for stardict. Russian to English"
HOMEPAGE="http://seclorum.msk.ru"

SRC_URI="ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Auto.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Biology.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Building.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Computers.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Engineering.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Essential.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Law.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_LingvoComputer.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_LingvoEconomics.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_LingvoScience.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_LingvoUniversal.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_MechanicalEngineering.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Medical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_OilAndGas.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Patents.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_PhraseBook.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Physics.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Polytechnical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_RU_EN_Telecoms.tar.gz"

LICENSE="Lingvo"
KEYWORDS="~x86 ~amd64"
SLOT="0"

IUSE="+Auto +Biology +Building +Computers +Engineering +Essential +Law +LingvoComputer +LingvoEconomics +LingvoScience +LingvoUniversal +MechanicalEngineering +Medical +OilAndGas +Patents +PhraseBook +Physics +Polytechnical +Telecoms"

RDEPEND=">=app-dicts/stardict-2.4.2"
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p ${D}/usr/share/stardict/dic
	
	if use Auto; then
		cp -R ${WORKDIR}/AutoRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Biology; then
		cp -R ${WORKDIR}/BiologyRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Building; then
		cp -R ${WORKDIR}/BuildingRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Computers; then
		cp -R ${WORKDIR}/ComputersRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Engineering; then
		cp -R ${WORKDIR}/EngineeringRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Essential; then
		cp -R ${WORKDIR}/EssentialRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Law; then
		cp -R ${WORKDIR}/LawRE.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoComputer; then
		cp -R ${WORKDIR}/LingvoComputerRE.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoEconomics; then
		cp -R ${WORKDIR}/LingvoEconomicsRE.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoScience; then
		cp -R ${WORKDIR}/LingvoScienceRE.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoUniversal; then
		cp -R ${WORKDIR}/LingvoUniversalRE.* ${D}/usr/share/stardict/dic/
	fi

	if use MechanicalEngineering; then
		cp -R ${WORKDIR}/MechanicalEngineeringRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Medical; then
		cp -R ${WORKDIR}/MedicalRE.* ${D}/usr/share/stardict/dic/
	fi

	if use OilAndGas; then
		cp -R ${WORKDIR}/OilAndGasRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Patents; then
		cp -R ${WORKDIR}/PatentsRE.* ${D}/usr/share/stardict/dic/
	fi

	if use PhraseBook; then
		cp -R ${WORKDIR}/PhraseBookRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Physics; then
		cp -R ${WORKDIR}/PhysicsRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Polytechnical; then
		cp -R ${WORKDIR}/PolytechnicalRE.* ${D}/usr/share/stardict/dic/
	fi

	if use Telecoms; then
		cp -R ${WORKDIR}/TelecomsRE.* ${D}/usr/share/stardict/dic/
	fi
}