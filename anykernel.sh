# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=povidevKernel-ginkgo
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=ginkgo
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot
is_slot_device=0;
ramdisk_compression=none;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

dump_boot;
mount -o rw /data;

if [ ! -d /data/adb/service.d ]; then
mkdir /data/adb;
mkdir /data/adb/service.d;
fi;

if [ -d $ramdisk/.backup ]; then
  ui_print " "; ui_print "Magisk detected! Reflashing Magisk is not necessary...";
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;
remove_section init.rc "service flash_recovery" "";
write_boot;

