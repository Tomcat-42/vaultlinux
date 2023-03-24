SUMMARY = "ciphervault"
DESCRIPTION = "a x509 der digital certificates wrapper library and command line application. "
HOMEPAGE = "https://github.com/tomcat-42/ciphervault"
LICENSE="CLOSED"
LIC_FILES_CHKSUM=""
INSANE_SKIP:${PN} += "already-stripped"
INSANE_SKIP:${PN} += "installed-vs-shipped"

# build time deps
# DEPENDS+= ""

# runtime deps
RDEPENDS:${PN} += "libcrypto libssl"
SRC_URI[sha256sum] = "8e09c937b06fe663b210b005431d63933913d01ba2cc187b64c4f6d4e12d9aaf"
SRC_URI = "https://github.com/Tomcat-42/ciphervault/releases/download/ciphervault/ciphervault.zip;protocol=http;subdir=ciphervault"
SRC_URI += "file://32k-rsa-example-cert.der"

FILES:${PN} += "/lib64"
FILES:${PN} += "/home"
FILES:${PN} += "32k-rsa-example-cert.der"

S = "${WORKDIR}/ciphervault/ciphervault"

do_install() {
        install -d ${D}${bindir}
        install -d ${D}${bindir}
        install -d ${D}/home/root
        install -m 0755 libcipher.a ${D}${libdir}
        install -m 0755 ciphervault ${D}${bindir}
        install -m 0755 ciphervault_test ${D}${bindir}
        install -m 0755 ciphervault_bench ${D}${bindir}
        # The binaries loader are linked agains /lib64/ld-linux-x86-64.so.2
        ln -rs ${D}/lib ${D}/lib64
        cp ${WORKDIR}/32k-rsa-example-cert.der ${D}/home/root
}
