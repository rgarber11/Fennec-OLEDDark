#!/bin/bash
apk=$(curl -s https://f-droid.org/repo/index-v1.json | jq -r '.packages."org.mozilla.fennec_fdroid" | map(select(any(.nativecode[]; . == "arm64-v8a"))) | max_by(.versionCode).apkName')
wget -q "https://fdroid.org/repo/$apk" -O latest.apk

wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.11.0.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool*

rm -rf patched patched_signed.apk
./apktool d latest.apk -o patched
rm -rf patched/META-INF

sed -i 's/<color name="fx_mobile_layer_color_1">.*/<color name="fx_mobile_layer_color_1">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_layer_color_2">.*/<color name="fx_mobile_layer_color_2">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml
# Change Reader Mode to also be OLED Dark
sed -i -z 's/.mozac-readerview-body.dark {\n  background-color: #1c1b22;/.mozac-readerview-body.dark {\n  background-color: #000000;/g' patched/assets/extensions/readerview/readerview.css

# Adding in OLED Tab from https://github.com/ArtikusHG/Ironfox-OLEDDark/issues/6#issuecomment-2613716936
sed -i 's/ff2b2a33/ff000000/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff42414d/ff15141a/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff52525e/ff15141a/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali

./apktool b patched -o patched.apk --use-aapt2

zipalign 4 patched.apk patched_signed.apk
rm -rf patched patched.apk
