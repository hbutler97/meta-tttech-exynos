FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/{MACHINE}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://exynos8890-at3-tttech_defconfig \
             file://exynos8890-at3-tttech.dts \
             file://exynos8890-acex-tttech.dts \
             file://sip.dts \
             file://exynos8890-acex-bb.dts \
             file://0001-add-kernel-config-to-enable-pcie-ch1.patch \
             file://0002-add-extra-condition-to-accept-pcie-ch0.patch \
            "

KDEFCONFIG = "exynos8890-at3-tttech_defconfig"
KDTS = "exynos8890-acex-bb.dts"

KERNEL_DEVICETREE ="exynos8890-acex-bb.dtb" 

do_configure_prepend() {
    install -m 0644 ${WORKDIR}/${KDEFCONFIG}  ${S}/arch/${ARCH}/configs/${KDEFCONFIG} 
    install -m 0644 ${WORKDIR}/${KDTS}  ${S}/arch/${ARCH}/boot/dts/${KDTS} 
}
