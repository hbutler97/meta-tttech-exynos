SUMMARY = "Neutrino PCIe-EMAC driver"
DESCRIPTION = "Cross-compiling Neutrino PCIe-eMAC driver for ACEX BaseBoard"
AUTHOR = "TTTech"
HOMEPAGE = "http://www.tttech.com"
SECTION = "PCIe-EMAC"
LICENSE = "CLOSED"

inherit module

SRC_URI = " git://github.com/ToshibaAmericaElectronicComponents/TOSHIBA_PCIe_EMAC_Driver.git;tag=V_00_06 \
            file://NTN_reference_driver_kernel-3.18.diff;patch=1  \
            file://0000-Adapt-makefile-for-crosscompiling.patch;patch=1 \
            file://0001-Modify-Neutrino-driver-to-load-FW-through-PCIe.patch \
            file://0002-Modify-MAC-address-value.patch \
            file://0100-Enable-DWC_ETH_QOS-debug-traces.patch;patch=1 \
            file://fw_OSLess_HWSeq_emac_tdm_can_v2.4.bin \
            file://0003-Set-MAC_HFR0_SMASEL_Mask-to-0.patch \
            file://0004-Set-MAC_HFR0_EEESEL_Mask-to-0.patch \
          "

SRC_URI[md5sum] = "b514c782f522750ad5722f762954d15a"
SRC_URI[sha256sum] = "f6f48796f7d3f2b8a7e13763674c09efcd87e5faf645aed8673f3b398f98e793"

S = "${WORKDIR}/git/"

FILES_${PN} += "${base_libdir}/firmware/*"

KERNEL_MODULE_AUTOLOAD = "DWC_ETH_QOS"

# Due to different line endings, it is necessary to apply the patch with options
do_patch() {
    patch -p2 --binary -d ${S} < NTN_reference_driver_kernel-3.18.diff
    patch -d ${S} < 0000-Adapt-makefile-for-crosscompiling.patch
    patch -d ${S} < 0001-Modify-Neutrino-driver-to-load-FW-through-PCIe.patch
    patch -d ${S} < 0002-Modify-MAC-address-value.patch
    #patch -d ${S} < 0100-Enable-DWC_ETH_QOS-debug-traces.patch
    patch -d ${S} < 0003-Set-MAC_HFR0_SMASEL_Mask-to-0.patch
    patch -d ${S} < 0004-Set-MAC_HFR0_EEESEL_Mask-to-0.patch
}

do_install_append() {
    install -d ${D}${base_libdir}/firmware
    install -m 0644 ${WORKDIR}/fw_OSLess_HWSeq_emac_tdm_can_v2.4.bin ${D}${base_libdir}/firmware/fw_OSLess_HWSeq_emac_tdm_can_v2.4.bin
}
