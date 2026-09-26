# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers
# miatoll (joyeuse/curtana/excalibur/gram) - RKSU+SUSFS kinesis

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RKSU SUSFS Kinesis miatoll (joyeuse MIUI14)
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=joyeuse
device.name2=curtana
device.name3=excalibur
device.name4=gram
device.name5=miatoll
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

## AnyKernel install
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see internal readme
. tools/ak3-core.sh;

# boot shell variables
BLOCK=$(find_slot_block "$block");
if mountpoint -q /data; then
  :
else
  mount /data 2>/dev/null;
fi;

## boot install
dump_boot;
write_boot;
## end boot install

# wlan module (qcacld rebuilt for this kernel -> needs matching vermagic)
if [ -f "$home/modules/wlan.ko" ]; then
  ui_print " ";
  ui_print "Installing wlan.ko...";
  mount /vendor 2>/dev/null;
  if [ -d /vendor/lib/modules ]; then
    cp -f "$home/modules/wlan.ko" /vendor/lib/modules/wlan.ko;
    chmod 644 /vendor/lib/modules/wlan.ko;
    ui_print "wlan.ko installed.";
  else
    ui_print "WARNING: /vendor/lib/modules not found, skipping wlan.ko.";
  fi;
  umount /vendor 2>/dev/null;
fi;

## end install
