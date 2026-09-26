#!/bin/bash
# Local build script (Ubuntu/Debian) - mirrors .github/workflows/build.yml
set -e
cd "$(dirname "$0")"

BASE_BRANCH="kinesis-MIUIv4"
BASE_REPO="https://github.com/clarencelol/kernel_xiaomi_sm6250.git"

echo "=== 1/6 clone base ==="
rm -rf kernel
git clone --depth 1 --branch "$BASE_BRANCH" "$BASE_REPO" kernel

echo "=== 2/6 apply patches ==="
cd kernel
for p in ../patches/*.patch; do
  echo "--- $(basename $p)"
  git apply --check "$p" && git apply "$p"
done
cd ..

echo "=== 3/6 toolchain (Neutron Clang) ==="
if [ ! -x "$(find neutron-clang -name clang -type f 2>/dev/null | head -1)" ]; then
  mkdir -p neutron-clang && cd neutron-clang
  bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S
  cd ..
fi
CLANG_BIN=$(dirname "$(find "$PWD/neutron-clang" -name clang -type f | head -1)")
export PATH="$CLANG_BIN:$PATH"

echo "=== 4/6 build ==="
cd kernel
make O=out ARCH=arm64 atoll-perf_defconfig
grep -E "CONFIG_KSU=|CONFIG_KSU_MANUAL_HOOK=|CONFIG_KSU_SUSFS=|CONFIG_NOMOUNT=|CONFIG_QCA_CLD_WLAN" out/.config
make O=out ARCH=arm64 -j$(nproc) LLVM=1 LLVM_IAS=1 CLANG_TRIPLE=aarch64-linux-gnu- Image.gz-dtb modules
cd ..

echo "=== 5/6 package ==="
rm -rf ak3 && git clone --depth 1 https://github.com/osm0sis/AnyKernel3.git ak3
rm -f ak3/anykernel.sh && cp anykernel.sh ak3/anykernel.sh
cp kernel/out/arch/arm64/boot/Image.gz-dtb ak3/
mkdir -p ak3/modules
find kernel/out -name "wlan.ko" -exec cp -v {} ak3/modules/ \;
cd ak3
OUT="../RKSU-SUSFS-kinesis-miatoll-joyeuse-$(date +%Y%m%d).zip"
zip -r9 "$OUT" * -x README.md .git\*
cd ..
echo "=== DONE: $(ls -lh *.zip | tail -1) ==="
