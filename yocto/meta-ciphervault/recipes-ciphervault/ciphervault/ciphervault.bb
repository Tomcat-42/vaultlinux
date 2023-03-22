SUMMARY = "ciphervault"
DESCRIPTION = "a x509 der digital certificates wrapper library and command line application. "
HOMEPAGE = "https://github.com/tomcat-42/ciphervault"
LICENSE="CLOSED"
LIC_FILES_CHKSUM=""
INSANE_SKIP:${PN} += "already-stripped"

# build time deps
# DEPENDS+= ""

# runtime deps
RDEPENDS:${PN} += "libcrypto libssl"
SRC_URI[sha256sum] = "8e09c937b06fe663b210b005431d63933913d01ba2cc187b64c4f6d4e12d9aaf"
SRC_URI = "https://github.com/Tomcat-42/ciphervault/releases/download/ciphervault/ciphervault.zip;protocol=http;subdir=ciphervault"

S = "${WORKDIR}/ciphervault/ciphervault"

do_install() {
        install -d ${D}${bindir}
        install -d ${D}${libdir}
        install -m 0755 libcipher.a ${D}${libdir}
        install -m 0755 ciphervault ${D}${bindir}
        install -m 0755 ciphervault_test ${D}${bindir}
        install -m 0755 ciphervault_bench ${D}${bindir}
}
