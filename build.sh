#!/bin/bash
apk=$(curl -s https://f-droid.org/repo/index-v1.json | jq -r 'first(.packages."org.mozilla.fennec_fdroid".[] | select(.nativecode[] | contains("arm64-v8a"))).apkName')
wget -q "https://fdroid.org/repo/$apk" -O latest.apk

wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.11.0.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool*

rm -rf patched patched_signed.apk
./apktool d -s latest.apk -o patched
rm -rf patched/META-INF

sed -i 's/<color name="fx_mobile_layer_color_1">.*/<color name="fx_mobile_layer_color_1">@color\/photonBlack<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_layer_color_2">.*/<color name="fx_mobile_layer_color_2">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml
# Change Reader Mode to also be OLED Dark
sed -i -z 's/.mozac-readerview-body.dark {\n  background-color: #1c1b22;/.mozac-readerview-body.dark {\n  background-color: #000000;/g' patched/assets/extensions/readerview/readerview.css

./apktool b patched -o patched.apk --use-aapt2

zipalign 4 patched.apk patched_signed.apk
rm -rf patched patched.apk
