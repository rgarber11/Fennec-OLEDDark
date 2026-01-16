#!/bin/bash
apk=$(curl -s https://f-droid.org/repo/index-v1.json | jq -r '.packages."org.mozilla.fennec_fdroid" | map(select(any(.nativecode[]; . == "arm64-v8a"))) | max_by(.versionCode).apkName')
wget -q "https://fdroid.org/repo/$apk" -O latest.apk
wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.12.0.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool*
rm -rf patched patched_signed.apk
./apktool d latest.apk -o patched
rm -rf patched/META-INF
sed -i 's/<color name="fx_mobile_surface">.*/<color name="fx_mobile_surface">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_background">.*/<color name="fx_mobile_background">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_surface_container">.*/<color name="fx_mobile_surface_container">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_layer_color_2">.*/<color name="fx_mobile_layer_color_2">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_surface_bright">.*/<color name="fx_mobile_surface_bright">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_action_color_secondary">.*/<color name="fx_mobile_action_color_secondary">#ff25242b<\/color>/g' patched/res/values-night/colors.xml
sed -i -z 's/.mozac-readerview-body.dark {\n  background-color: #1c1b22;/.mozac-readerview-body.dark {\n  background-color: #000000;/g' patched/assets/extensions/readerview/readerview.css
loc=$(find ./patched -name "PhotonColors.smali" -type f -print -quit)
sed -i 's/ff1c1b22/ff000000/g' "$loc"
sed -i 's/ff2b2a33/ff000000/g' "$loc"
sed -i 's/ff42414d/ff15141a/g' "$loc"
sed -i 's/ff52525e/ff15141a/g' "$loc"
sed -i 's/mipmap\/ic_launcher_round/drawable\/ic_launcher_foreground/g' patched/res/drawable/splash_screen.xml
sed -i 's/160\.0dip/200\.0dip/g' patched/res/drawable/splash_screen.xml
./apktool b patched -o patched.apk
zipalign 4 patched.apk patched_signed.apk
rm -rf patched patched.apk
