# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils versionator

MY_PV1=${PV%.*.*}

DESCRIPTION="Collection of Lingvo dicts for stardict. English to Russian"
HOMEPAGE="http://seclorum.msk.ru"

SRC_URI="
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Accounting.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Americana.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Auto.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Biology.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Building.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Computers.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Engineering.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Essential.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_FinancialManagement.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_FinancialMarkets.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_GreatBritain.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Informal.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Law.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_LingvoComputer.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_LingvoEconomics.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_LingvoGrammar.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_LingvoScience.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_LingvoUniversal.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Management.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Marketing.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_MechanicalEngineering.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Medical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_OilAndGas.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Patents.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Physics.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Polytechnical.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Telecoms.tar.gz
ftp://seclorum.msk.ru/etc/gentoo/portage/distfiles/LS${MY_PV1}_EN_RU_Wine.tar.gz"

LICENSE="Lingvo"
KEYWORDS="~x86 ~amd64"
SLOT="0"

IUSE="+Accounting +Americana +Auto +Biology +Building +Computers +Engineering +Essential +FinancialManagement +FinancialMarkets +GreatBritain +Informal +Law +LingvoComputer +LingvoEconomics +LingvoGrammar +LingvoScience +LingvoUniversal +Management +Marketing +MechanicalEngineering +Medical +OilAndGas +Patents +Physics +Polytechnical +Telecoms +Wine"

RDEPEND=">=app-dicts/stardict-2.4.2"

DEPEND="${RDEPEND}"

src_install() {
	mkdir -p ${D}/usr/share/stardict/dic
	
	if use Accounting; then
		cp -R ${WORKDIR}/AccountingER.* ${D}/usr/share/stardict/dic/
	fi

	if use Americana; then
		cp -R ${WORKDIR}/AmericanaER.* ${D}/usr/share/stardict/dic/
	fi

	if use Auto; then
		cp -R ${WORKDIR}/AutoER.* ${D}/usr/share/stardict/dic/
	fi

	if use Biology; then
		cp -R ${WORKDIR}/BiologyER.* ${D}/usr/share/stardict/dic/
	fi

	if use Building; then
		cp -R ${WORKDIR}/BuildingER.* ${D}/usr/share/stardict/dic/
	fi

	if use Computers; then
		cp -R ${WORKDIR}/ComputersER.* ${D}/usr/share/stardict/dic/
	fi

	if use Engineering; then
		cp -R ${WORKDIR}/EngineeringER.* ${D}/usr/share/stardict/dic/
	fi

	if use Essential; then
		cp -R ${WORKDIR}/EssentialER.* ${D}/usr/share/stardict/dic/
	fi

	if use FinancialManagement; then
		cp -R ${WORKDIR}/FinancialManagementER.* ${D}/usr/share/stardict/dic/
	fi

	if use FinancialMarkets; then
		cp -R ${WORKDIR}/FinancialMarketsER.* ${D}/usr/share/stardict/dic/
	fi

	if use GreatBritain; then
		cp -R ${WORKDIR}/GreatBritainER.* ${D}/usr/share/stardict/dic/
	fi

	if use Informal; then
		cp -R ${WORKDIR}/InformalER.* ${D}/usr/share/stardict/dic/
	fi

	if use Law; then
		cp -R ${WORKDIR}/LawER.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoComputer; then
		cp -R ${WORKDIR}/LingvoComputerER.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoEconomics; then
		cp -R ${WORKDIR}/LingvoEconomicsER.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoGrammar; then
		cp -R ${WORKDIR}/LingvoGrammarER.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoScience; then
		cp -R ${WORKDIR}/LingvoScienceER.* ${D}/usr/share/stardict/dic/
	fi

	if use LingvoUniversal; then
		cp -R ${WORKDIR}/LingvoUniversalER.* ${D}/usr/share/stardict/dic/
	fi

	if use Management; then
		cp -R ${WORKDIR}/ManagementER.* ${D}/usr/share/stardict/dic/
	fi

	if use Marketing; then
		cp -R ${WORKDIR}/MarketingER.* ${D}/usr/share/stardict/dic/
	fi

	if use MechanicalEngineering; then
		cp -R ${WORKDIR}/MechanicalEngineeringER.* ${D}/usr/share/stardict/dic/
	fi

	if use Medical; then
		cp -R ${WORKDIR}/MedicalER.* ${D}/usr/share/stardict/dic/
	fi

	if use OilAndGas; then
		cp -R ${WORKDIR}/OilAndGasER.* ${D}/usr/share/stardict/dic/
	fi

	if use Patents; then
		cp -R ${WORKDIR}/PatentsER.* ${D}/usr/share/stardict/dic/
	fi

	if use Physics; then
		cp -R ${WORKDIR}/PhysicsER.* ${D}/usr/share/stardict/dic/
	fi

	if use Polytechnical; then
		cp -R ${WORKDIR}/PolytechnicalER.* ${D}/usr/share/stardict/dic/
	fi

	if use Telecoms; then
		cp -R ${WORKDIR}/TelecomsER.* ${D}/usr/share/stardict/dic/
	fi

	if use Wine; then
		cp -R ${WORKDIR}/WineER.* ${D}/usr/share/stardict/dic/
	fi

}