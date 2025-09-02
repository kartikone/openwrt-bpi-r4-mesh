set -e

echo "==== 1. LIMPIEZA ===="
rm -rf openwrt mtk-openwrt-feeds tmp_comxwrt

echo "==== 2. CLONA REPOSITORIOS (kernel 6.6.100) ===="
git clone --branch main https://github.com/brudalevante/openwrt-espejo.git openwrt || true
cd openwrt; git checkout 4941509f573676c4678115a0a3a743ef78b63c17; cd -;	# uhttpd: update to Git HEAD (2025-07-06) kernel 6.6.100

git clone https://github.com/brudalevante/mtk-openwrt-feeds-18-08-2025.git mtk-openwrt-feeds || true
cd mtk-openwrt-feeds; git checkout 39d725c3e3b486405e6148c8466111ef13516808; cd -; # Refactor wed amsdu init value

echo "39d725" > mtk-openwrt-feeds/autobuild/unified/feed_revision

cp -r my_files/w-autobuild.sh mtk-openwrt-feeds/autobuild/unified/autobuild.sh
cp -r my_files/w-rules mtk-openwrt-feeds/autobuild/unified/filogic/rules


rm -rf mtk-openwrt-feeds/24.10/patches-feeds/108-strongswan-add-uci-support.patch

# === BLOQUE CRÍTICO PARA WIFI Y EVITAR PERF ===
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/defconfig
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7988_wifi7_mac80211_mlo/.config
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7986_mac80211/.config

echo "==== 4. COPIA PARCHES ===="
cp -r my_files/1007-wozi-arch-arm64-dts-mt7988a-add-thermal-zone.patch mtk-openwrt-feeds/24.10/patches-base/
cp -r my_files/200-wozi-libiwinfo-fix_noise_reading_for_radios.patch openwrt/package/network/utils/iwinfo/patches
cp -r my_files/99999_tx_power_check.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/
cp -r my_files/999-2764-net-phy-sfp-add-some-FS-copper-SFP-fixes.patch openwrt/target/linux/mediatek/patches-6.6/

echo "==== 5. CLONA Y COPIA PAQUETES PERSONALIZADOS ===="
git clone --depth=1 --single-branch --branch main https://github.com/brudalevante/fakemesh-6g-clon.git tmp_comxwrt
cp -rv tmp_comxwrt/luci-app-fakemesh openwrt/package/
cp -rv tmp_comxwrt/luci-app-autoreboot openwrt/package/
cp -rv tmp_comxwrt/luci-app-cpu-status openwrt/package/
cp -rv tmp_comxwrt/luci-app-temp-status openwrt/package/
cp -rv tmp_comxwrt/luci-app-dawn2 openwrt/package/
cp -rv tmp_comxwrt/luci-app-usteer2 openwrt/package/

echo "==== 6. COPIA ARCHIVOS DE CONFIG PERSONALIZADOS ===="
mkdir -p openwrt/package/base-files/files/etc/config
mkdir -p openwrt/package/base-files/files/etc

cp -v configs/network openwrt/package/base-files/files/etc/config/network
cp -v configs/system openwrt/package/base-files/files/etc/config/system
cp -v configs/wireless openwrt/package/base-files/files/etc/config/wireless
cp -v my_files/board.json openwrt/package/base-files/files/etc/board.json

echo "==== 7. ENTRA EN OPENWRT Y CONFIGURA FEEDS ===="
cd openwrt

rm -rf feeds/
cat feeds.conf.default

echo "==== 8. COPIA LA CONFIGURACIÓN BASE (mm_perf.config) ===="
cp -v ../configs/config_mm_06082025 .config

echo "==== 9. COPIA TU CONFIGURACIÓN PERSONALIZADA AL DEFCONFIG DEL AUTOBUILD ===="
cp -v ../configs/config_mm_06082025 ../mtk-openwrt-feeds/autobuild/unified/filogic/24.10/defconfig

# === BLOQUE ANTI-MLO ULTRA ===
echo "==== 10B. DESACTIVA MLO EN TODOS LOS .config, defconfig y Makefile ===="
find ../mtk-openwrt-feeds/ -type f \( -name "*.config" -o -name "defconfig" \) -exec \
  sed -i \
    -e 's/^CONFIG_MTK_MLO=y/# CONFIG_MTK_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI_MLO=y/# CONFIG_MTK_WIFI_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI7_MLO=y/# CONFIG_MTK_WIFI7_MLO is not set/' \
    -e 's/^CONFIG_MAC80211_MLO=y/# CONFIG_MAC80211_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI_MAC80211_MLO=y/# CONFIG_MTK_WIFI_MAC80211_MLO is not set/' \
    -e 's/^CONFIG_MLO_SUPPORT=y/# CONFIG_MLO_SUPPORT is not set/' {} +

find ../mtk-openwrt-feeds/ -type f \( -name "Makefile" -o -name "Kconfig" \) -exec \
  sed -i \
    -e '/select.*MLO/d' \
    -e '/depends.*MLO/d' \
    -e '/CONFIG_MTK_MLO:=y/d' \
    -e '/CONFIG_MTK_WIFI_MLO:=y/d' \
    -e '/CONFIG_MTK_WIFI7_MLO:=y/d' \
    -e '/CONFIG_MAC80211_MLO:=y/d' \
    -e '/CONFIG_MTK_WIFI_MAC80211_MLO:=y/d' \
    -e '/CONFIG_MLO_SUPPORT:=y/d' {} +

# También fuerza el .config de openwrt principal
sed -i \
    -e 's/^CONFIG_MTK_MLO=y/# CONFIG_MTK_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI_MLO=y/# CONFIG_MTK_WIFI_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI7_MLO=y/# CONFIG_MTK_WIFI7_MLO is not set/' \
    -e 's/^CONFIG_MAC80211_MLO=y/# CONFIG_MAC80211_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI_MAC80211_MLO=y/# CONFIG_MTK_WIFI_MAC80211_MLO is not set/' \
    -e 's/^CONFIG_MLO_SUPPORT=y/# CONFIG_MLO_SUPPORT is not set/' .config

echo "==== 10. ACTUALIZA E INSTALA FEEDS ===="
./scripts/feeds update -a
./scripts/feeds install -a

echo "==== 11. RESUELVE DEPENDENCIAS ===="
make defconfig

# === BLOQUE ANTI-MLO ULTRA POST-defconfig ===
echo "==== 11B. REAFIRMA DESACTIVACIÓN MLO EN .config y Makefiles ===="
sed -i \
    -e 's/^CONFIG_MTK_MLO=y/# CONFIG_MTK_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI_MLO=y/# CONFIG_MTK_WIFI_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI7_MLO=y/# CONFIG_MTK_WIFI7_MLO is not set/' \
    -e 's/^CONFIG_MAC80211_MLO=y/# CONFIG_MAC80211_MLO is not set/' \
    -e 's/^CONFIG_MTK_WIFI_MAC80211_MLO=y/# CONFIG_MTK_WIFI_MAC80211_MLO is not set/' \
    -e 's/^CONFIG_MLO_SUPPORT=y/# CONFIG_MLO_SUPPORT is not set/' .config

find ../mtk-openwrt-feeds/ -type f \( -name "Makefile" -o -name "Kconfig" \) -exec \
  sed -i \
    -e '/select.*MLO/d' \
    -e '/depends.*MLO/d' \
    -e '/CONFIG_MTK_MLO:=y/d' \
    -e '/CONFIG_MTK_WIFI_MLO:=y/d' \
    -e '/CONFIG_MTK_WIFI7_MLO:=y/d' \
    -e '/CONFIG_MAC80211_MLO:=y/d' \
    -e '/CONFIG_MTK_WIFI_MAC80211_MLO:=y/d' \
    -e '/CONFIG_MLO_SUPPORT:=y/d' {} +

echo "==== 12. VERIFICACIÓN FINAL ===="
for pkg in \
  fakemesh autoreboot cpu-status temp-status dawn2 dawn usteer2 wireguard
do
  grep $pkg .config || echo "NO aparece $pkg en .config"
done

grep "CONFIG_PACKAGE_kmod-wireguard=y" .config || echo "ATENCIÓN: kmod-wireguard NO está marcado"
grep "CONFIG_PACKAGE_wireguard-tools=y" .config || echo "ATENCIÓN: wireguard-tools NO está marcado"
grep "CONFIG_PACKAGE_luci-proto-wireguard=y" .config || echo "ATENCIÓN: luci-proto-wireguard NO está marcado"

# === BLOQUE DE CHEQUEO FINAL DE MLO ===
echo "==== 12B. CHEQUEO DE MLO EN configs y Makefiles ===="
grep -rni --color=auto mlo ../mtk-openwrt-feeds/ | grep -E 'MLO|mlo|=y|:=y|select|depends' && echo "¡¡¡ATENCIÓN!!! MLO SIGUE ACTIVO" || echo "Ok, MLO desactivado (no hay MLO forzado en configs ni Makefiles)"

echo "==== 13. EJECUTA AUTOBUILD ===="
bash ../mtk-openwrt-feeds/autobuild/unified/autobuild.sh filogic-mac80211-mt7988_rfb-mt7996 log_file=make

# ==== ELIMINAR EL WARNING EN ROJO DEL MAKEFILE ====
sed -i 's/\($(call ERROR_MESSAGE,WARNING: Applying padding.*\)/#\1/' package/Makefile

echo "==== ELIMINA WARNING SHA-512 DE scripts/ipkg-make-index.sh ===="
if grep -q "WARNING: Applying padding" scripts/ipkg-make-index.sh; then
  sed -i '/WARNING: Applying padding/d' scripts/ipkg-make-index.sh
fi

echo "==== 14. COMPILA ===="
make -j$(nproc)

echo "==== 15. LIMPIEZA FINAL ===="
cd ..
rm -rf tmp_comxwrt

echo "==== Script finalizado correctamente ===="
