# DrWebES ebuild by Mark Silinio <silinio[at]fromru.com>

inherit eutils

DESCRIPTION="Linux server part of DrWeb Enterprice Suite"
HOMEPAGE="http://www.drweb.com/"
SRC_URI="ftp://ftp.avtlg.ru/Aids/DRWEB/drweb/esuite/drweb-es-4.33-200510280-linux-debian-sid.tar.gz
         ftp://ftp.avtlg.ru/Aids/DRWEB/drweb/esuite/drweb-es-4.33-200510280-unices.tar.gz"

LICENSE="DOCTOR WEB, LTD. EULA"
SLOT="0"
KEYWORDS="x86"
IUSE="postgres doc"

DEPEND="virtual/libc
	postgres? ( dev-db/postgresql )"

RESTRICT="nostrip nomirror"

INSTALLDIR="/opt/drweb-es"

linguas_warn() {
ewarn "Language ${LANG[0]} not avaliable"
ewarn "Language set to English"
ewarn "If this is a mistake, please set the"
ewarn "First LINGUAS language to one of the following"
ewarn
ewarn "en - English"
ewarn "fr - French"
ewarn "pl - Polish"
ewarn "ru - Russian"
export LINGUAS="en ${LINGUAS}"
}


pkg_preinst () {
    enewgroup drwcs
    enewuser drwcs -1 /bin/sh /opt/drweb-es drwcs
}

src_install() {


dodir ${INSTALLDIR}
cd ${WORKDIR}
mv bin ${D}${INSTALLDIR}
mv etc ${D}${INSTALLDIR}
mv lib ${D}${INSTALLDIR}
mkdir -p ${D}${INSTALLDIR}/var/templates

case $LINGUAS in 
"ru") 
mv templates/Russian/* ${D}${INSTALLDIR}/var/templates
einfo "Setting console language to Russian"
;;
"pl") 
mv templates/Polish/* ${D}${INSTALLDIR}/var/templates
einfo "Setting console language to Polish"
;;
"fr") 
mv templates/French/* ${D}${INSTALLDIR}/var/templates
einfo "Setting console language to French"
;;
* ) 
mv templates/English/* ${D}${INSTALLDIR}/var/templates
einfo "Setting console language to English"
;;
esac 

#mv templates ${D}${INSTALLDIR}/var
mv repository ${D}${INSTALLDIR}/var
chown -R drwcs:drwcs ${D}/opt/drweb-es
chmod -R 750 ${D}${INSTALLDIR}/etc # to protect keys&conf

doenvd "${FILESDIR}"/10drwes
newinitd ${FILESDIR}/drwes.rc drweb-es

dodoc doc/ChangeLog.Console doc/Changelog.drwcs doc/installer-rexx-api.quickref doc/repository.quickref doc/drweb-es-EULA-en.html doc/drweb-es-EULA-pl.html doc/drweb-es-EULA-ru.html

if use doc ; then
 cp -r doc/html "${D}/usr/share/doc/${PF}/" || die
 echo
 einfo "russian-only html documentation in /usr/share/doc/${PF}"
 echo
fi
}
