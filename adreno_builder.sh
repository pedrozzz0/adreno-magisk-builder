#!/system/bin/sh
# Adreno Magisk Driver Builder
# GPL 3.0 or later
# By p3dr0 (pedrozzz0 @ Github)
# TODO: Dynamically download *_sqe and *_gmu

if [ $# -eq 0 ]; then
    echo "Adreno GPU Driver Builder 1.0
by pedrozzz0
Usage: ./adreno_builder.sh [vendor] [device_model/codename] [branch]
E.G. : ./adreno_builder.sh asus asus_ai2002 qssi-user-13-TKQ1.220807.001-33.0804.2060.142-release-keys
Libraries are from dumps.tadiphone.dev, change the URLs to use other sources.
Telegram group: https://t.me/kingprojectz"
    exit
fi

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Missing arguments. Vendor, device model and branch are required."
    exit 1
fi

url1="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/lib/"
url2="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/lib64/"
url3="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/lib/egl/"
url4="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/lib64/egl/"
url5="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/lib/hw/"
url6="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/lib64/hw/"
url7="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/gpu/kbc/"
url8="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/vendor/firmware/"
url9="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/system/system/lib/"
url10="https://dumps.tadiphone.dev/dumps/$1/$2/-/raw/$3/system/system/lib64/"

[ ! -d $(pwd)/system ] && {
mkdir -p $(pwd)/system/vendor/firmware \
         $(pwd)/system/vendor/gpu/kbc \
         $(pwd)/system/vendor/lib/egl \
         $(pwd)/system/vendor/lib/hw \
		 $(pwd)/system/vendor/lib64/egl \
		 $(pwd)/system/vendor/lib64/hw \
		 $(pwd)/system/system/lib \
		 $(pwd)/system/system/lib64
} || {
	rm -rf $(pwd)/system/vendor/firmware/* # Remove existing FW just in case
}

move_file() {
  local url="$1"
  local destination="$2"

  shift 2 # Shift to skip URL and destination

  for lib do
    if ! curl -Sf -OJL "${url}${lib}"; then
      echo "Error: Failed to download ${lib} from ${url}${lib}"
      continue
    fi
    mv "$lib" "$destination"
  done
}

move_file "$url1" "$(pwd)/system/vendor/lib/" \
  libadreno_app_profiles.so \
  libadreno_utils.so \
  libbase64.so \
  libCB.so \
  libkcl.so \
  libEGL_adreno.so \
  libkernelmanager.so \
  libGLESv2_adreno.so \
  libllvm-glnext.so \
  libOpenCL.so \
  libllvm-qcom.so \
  libadreno_app_profiles.so \
  libllvm-qgl.so \
  libgame_enhance.so \
  libgpu_tonemapper.so \
  libgpudataproducer.so \
  libgsl.so \
  libq3dtools_adreno.so \
  libopencv.so \
  libopencv3a.so

move_file "$url2" "$(pwd)/system/vendor/lib64/" \
  libadreno_app_profiles.so \
  libadreno_utils.so \
  libbase64.so \
  libCB.so \
  libkcl.so \
  libEGL_adreno.so \
  libkernelmanager.so \
  libGLESv2_adreno.so \
  libllvm-glnext.so \
  libOpenCL.so \
  libllvm-qcom.so \
  libllvm-qgl.so \
  libgame_enhance.so \
  libgpu_tonemapper.so \
  libgpudataproducer.so \
  libgsl.so \
  libq3dtools_adreno.so \
  libopencv.so \
  libopencv3a.so

move_file "$url3" "$(pwd)/system/vendor/lib/egl/" \
  eglSubDriverAndroid.so \
  libVkLayer_ADRENO_qprofiler.so \
  libEGL_adreno.so \
  libq3dtools_adreno.so \
  libGLESv1_CM_adreno.so \
  libGLESv2_adreno.so \
  libq3dtools_esx.so

move_file "$url4" "$(pwd)/system/vendor/lib64/egl/" \
  eglSubDriverAndroid.so \
  libVkLayer_ADRENO_qprofiler.so \
  libEGL_adreno.so \
  libq3dtools_adreno.so \
  libGLESv1_CM_adreno.so \
  libGLESv2_adreno.so \
  libq3dtools_esx.so

move_file "$url5" "$(pwd)/system/vendor/lib/hw/" \
  android.hardware.renderscript@1.0-impl.so \
  gralloc.default.so \
  vulkan.adreno.so 

move_file "$url6" "$(pwd)/system/vendor/lib64/hw/" \
  android.hardware.renderscript@1.0-impl.so \
  gralloc.default.so \
  vulkan.adreno.so 

move_file "$url7" "$(pwd)/system/vendor/gpu/kbc/" \
  sequence_manifest.bin \
  unified_kbcs_32.bin \
  unified_kbcs_64.bin \
  unified_ksqs.bin 

move_file "$url8" "$(pwd)/system/vendor/firmware/" \
  a619_sqe.fw \
  a619_gmu.bin \
  a630_sqe.fw \
  a630_gmu.bin \
  a650_sqe.fw \
  a650_gmu.bin \
  a660_sqe.fw \
  a660_gmu.bin \
  a662_sqe.fw \
  a662_gmu.bin \
  a710_sqe.fw \
  a710_gmu.bin \
  a730_sqe.fw \
  a730_gmu.bin \
  a740_sqe.fw \
  a740_gmu.bin

move_file "$url9" "$(pwd)/system/system/lib/" \
  libdmabufheap.so

move_file "$url10" "$(pwd)/system/system/lib64/" \
  libdmabufheap.so

if [ ! -d "$(pwd)/META-INF" ]; then
mkdir -p $(pwd)/META-INF/com/google/android/
echo "#!/sbin/sh

#################
# Initialization
#################

umask 022

# echo before loading util_functions
ui_print() { echo \"\$1\"; }

require_new_magisk() {
    ui_print \"*******************************\"
    ui_print \" Please install Magisk v20.4+! \"
    ui_print \"*******************************\"
    exit 1
}

#########################
# Load util_functions.sh
#########################

OUTFD=\$2
ZIPFILE=\$3

mount /data 2>/dev/null

[[ -f \"/data/adb/magisk/util_functions.sh\" ]] || require_new_magisk
. /data/adb/magisk/util_functions.sh

[[ \"\$MAGISK_VER_CODE\" -lt \"20400\" ]] && require_new_magisk

install_module
exit 0
" > $(pwd)/META-INF/com/google/android/update-binary
echo "#MAGISK" > $(pwd)/META-INF/com/google/android/updater-script
fi

if [ ! -f $(pwd)/customize.sh ]; then
echo 'ui_print "- Adreno GPU Driver by p3dr0"
ui_print ""
ui_print "- This GPU driver may not work properly in some custom roms"

# add path
set_perm_recursive $MODPATH/system/vendor 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/lib* 0 0 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH  0  0  0755  0644
set_perm_recursive $MODPATH/system/vendor/firmware 0 0 0755 0644 u:object_r:vendor_firmware_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/egl/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/egl/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/gpu/kbc/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/gpu/kbc/sequence manifest.bin 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/gpu/kbc/unified_kbcs_32.bin 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/gpu/kbc/unified_kbcs_64.bin 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/gpu/kbc/unified_ksqs.bin 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/egl/eglSubDriverAndroid.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/egl/eglSubDriverAndroid.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/egl/libEGL_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/egl/libEGL_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/egl/libGLES_CM_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/egl/libGLES_CM_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/egl/libGLESv2_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/egl/libGLESv2_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libq3dtools_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libq3dtools_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libq3dtools_esx.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libq3dtools_esx.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libVkLayer_ADRENO_qprofiler.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libVkLayer_ADRENO_qprofiler.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/hw/vulkan.adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/hw/vulkan.adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libadreno_app_profiles.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libadreno_utils.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libbase64.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libCB.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/system/lib/libdmabufheap.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libEGL_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libgame_enhance.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libGLESv2_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libgpu_tonemapper.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libgpudataproducer.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libgsl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libkcl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libkernelmanager.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-glnext.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-qcom.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-qgl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libOpenCL.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libopencv.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libopencv3a.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libopenvx.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libq3dtools_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libVkLayer_q3dtools.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libadreno_app_profiles.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libadreno_utils.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libbase64.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libCB.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/system/lib64/libdmabufheap.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libEGL_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libgame_enhance.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libGLESv2_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libgpu_tonemapper.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libgpudataproducer.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libgsl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libkcl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libkernelmanager.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libllvm-glnext.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libllvm-qcom.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libllvm-qgl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libOpenCL.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libopencv.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libopencv3a.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libopenvx.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libq3dtools_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libVkLayer_q3dtools.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
chmod 644 /system/vendor/firmware/a619_sqe.fw
chmod 644 /system/vendor/firmware/a619_gmu.bin
chmod 644 /system/vendor/firmware/a630_sqe.fw
chmod 644 /system/vendor/firmware/a630_gmu.bin
chmod 644 /system/vendor/firmware/a650_sqe.fw
chmod 644 /system/vendor/firmware/a650_gmu.bin
chmod 644 /system/vendor/firmware/a660_sqe.fw
chmod 644 /system/vendor/firmware/a660_gmu.bin
chmod 644 /system/vendor/firmware/a662_sqe.fw
chmod 644 /system/vendor/firmware/a662_gmu.bin
chmod 644 /system/vendor/firmware/a710_sqe.fw
chmod 644 /system/vendor/firmware/a710_gmu.bin
chmod 644 /system/vendor/firmware/a730_sqe.fw
chmod 644 /system/vendor/firmware/a730_gmu.bin
chmod 644 /system/vendor/firmware/a740_sqe.fw
chmod 644 /system/vendor/firmware/a740_gmu.bin

# Shader cache
CACHE=$(find /data/user_de -name *shaders_cache* -type f | grep code_cache)
for i in $CACHE; do
    rm -rf $i
done

for i in "$(find /data -type f -name '*shader*')"; do
 rm -f $i
done

ui_print ""
ui_print "- Reboot to the drivers be applied"
ui_print ""
' > $(pwd)/customize.sh
fi

if [ ! -f "$(pwd)/system.prop" ]; then
echo "# Zygote HideCrash Fix
ro.zygote.disable_gl_preload=1
" > $(pwd)/system.prop
fi

if [ ! -f "$(pwd)/module.prop" ]; then
echo "id=adreno_driver
name=Adreno GPU driver
version=v1
versionCode=1
author=pedro
description=OpenGL & Vulkan driver
" > $(pwd)/module.prop
fi

if [ $(command -v zip) ]; then
	echo "Process done, zip the driver?"
	read compact
	if [ "$compact" = "Y" ] || [ "$compact" = "y" ]; then
	echo "Input the driver name: "
	read driver_name
	fi
	zip -r9 "$driver_name.zip" . -x adreno_builder.sh -x README.md -x LICENSE -x *.git* -x *zip
	echo "Done!"
else
	echo "Process done!"
fi