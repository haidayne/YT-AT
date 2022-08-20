# Kakathic

Likk="$GITHUB_WORKSPACE"

Taive () { curl -s -L --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L --connect-timeout 20 "$1"; }
Getpro () { grep -m1 "$1=" $Likk/Custom.md | cut -d = -f2; }

ListTM="lib
tmp
Up
Tav
apk"

for Vak in $ListTM; do
mkdir -p $Vak
done

# Tải tool Revanced
Tv1="$(Xem https://github.com/revanced/revanced-cli/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv1" "$Likk/lib/revanced-cli.jar"
Tv2="$(Xem https://github.com/revanced/revanced-patches/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv2" "$Likk/lib/revanced-patches.jar"
Tv3="$(Xem https://github.com/revanced/revanced-integrations/releases | grep '/releases/download' | grep -m1 '.apk' | cut -d \" -f2)"
Taive "https://github.com$Tv3" "$Likk/lib/revanced-integrations.apk"

# Tải Youtube

Taiyt () {
Upk="https://www.apkmirror.com"
User="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
Url1="$(curl -s -k -L -G -H "$User" "$Upk/apk/google-inc/youtube/youtube-$(Getpro Version)-release/youtube-$(Getpro Version)$2-android-apk-download/" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Url2="$Upk$(curl -s -k -L -G -H "$User" "$Upk$Url1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
curl -s -k -L -H "$User" $Url2 -o $Likk/lib/$1
}

Taiyt 'YouTube.apk' '-2'
Taiyt 'YouTube.apks'

Vision="$(echo $(Getpro Version) | tr '-' '.')"
Vision2="$(echo $(Getpro Version) | sed 's|-||g')"

echo "version=$Vision
versionCode=$Vision2" >> $Likk/Module/module.prop

unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Module/common

if [ "$(Getpro Device)" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "$(Getpro Device)" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "$(Getpro Device)" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

cp -rf $Likk/bin/sqlite3_$ach $Likk/Module/common/sqlite3
cp -rf "$Likk/lib/YouTube.apk" "$Likk/lib/YouTube2.apk"

zip -q -r "$Likk/lib/YouTube.apk" -d 'lib/*'
zip -q -r "$Likk/lib/YouTube2.apk" -d $lib

unzip -qo "$Likk/lib/YouTube2.apk" 'lib/*' -d $Likk/Tav
mv -f $Likk/Tav/lib/$(Getpro Device) $Likk/Tav/lib/$ach
cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz

[ "$(Getpro Icons)" == 1 ] && icon="-e custom-branding"
[ "$(Getpro Amoled)" == 1 ] && amoled="-e amoled"

for vakl in $(Getpro Feature); do
echo -n "-e $vakl " >> $Likk/logk
done

java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/Module/common/YouTube.apk" -t $Likk/tmp --cn=kakathic $(cat $Likk/logk) $icon $amoled --mount

java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube2.apk" -o "$Likk/Up/YouTube_Microg.apk" -t $Likk/tmp --cn=kakathic $(cat $Likk/logk) -e microg-support $icon $amoled --mount >/dev/null

cd $Likk/Module
zip -q -r $Likk/Up/YouTube_$Vision_$ach.Zip *
