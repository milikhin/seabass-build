APP_VERSION="0.5.0" # Exmaples for specific versions: 0.4.0, master
APP_VVERSION="v0.5.0" # Examples for specific versions: v0.4.0, master


N_STEPS=8
CORDOVA_PPA_URL="http://ppa.launchpad.net/cordova-ubuntu/ppa/ubuntu"
CORDOVA_PPA="ppa:cordova-ubuntu/ppa"
SDK_PPA_URL="http://ppa.launchpad.net/ubuntu-sdk-team/ppa/ubuntu"
SDK_PPA="ppa:ubuntu-sdk-team/ppa"

echo "Removing previous versions"
rm -rf ./seabass-*;
echo "DONE";
echo

echo "1/$N_STEPS. Installing NodeJS and required NPM packages"
sudo apt install nodejs npm

echo
command -v gulp >/dev/null 2>&1 || { 
    echo >&2 "Installing gulp"; 
    sudo npm i -g gulp;
}

command -v bower >/dev/null 2>&1 || { 
    echo >&2 "Installing bower"; 
    sudo npm i -g bower;
}

echo "DONE";
echo

echo "2/$N_STEPS. Checking Cordova PPA"https://github.com/milikhin/seabass/blob/master/building.md
if ! grep -q "$CORDOVA_PPA_URL" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Cordova PPA to apt sources"
    sudo apt-add-repository $CORDOVA_PPA
else
    echo "Cordova PPA already added to sources.list. Skipping."
fi
echo "DONE";
echo

echo "3/$N_STEPS. Checking Ubuntu SDK PPA"
if ! grep -q "$SDK_PPA_URL" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Ubuntu SDK PPA to apt sources"
    sudo apt-add-repository $SDK_PPA
else
    echo "Ubuntu SDK PPA already added to sources.list. Skipping."
fi
echo "DONE";
echo

echo "4/$N_STEPS. Installing build tools"
sudo apt update
sudo apt install cordova-cli
sudo apt install click-dev phablet-tools
sudo click chroot -a armhf -f ubuntu-sdk-15.04 install cmake libicu-dev:armhf pkg-config qtbase5-dev:armhf qtchooser qtdeclarative5-dev:armhf qtfeedback5-dev:armhf qtlocation5-dev:armhf qtmultimedia5-dev:armhf qtpim5-dev:armhf libqt5sensors5-dev:armhf qtsystems5-dev:armhf
echo "DONE";
echo

echo "5/$N_STEPS. Preparing Seabass sources"
wget https://github.com/milikhin/seabass/archive/$APP_VVERSION.tar.gz
tar -xf $APP_VVERSION.tar.gz
rm $APP_VVERSION.tar.gz
echo "DONE";
echo

echo "6/$N_STEPS. Installing app dependencies"
cd seabass-$APP_VERSION
mkdir www
cordova platform add https://github.com/milikhin/cordova-ubuntu.git --usegit
cordova plugin add https://github.com/milikhin/cordova-plugin-file.git 
cordova plugin add https://github.com/milikhin/cordova-plugin-dialogs.git
(npm install; cd src; bower install;)
echo "DONE";
echo

echo "7/$N_STEPS. Building sources"
gulp build

echo
echo
echo "The task is COMPLETE, though I don't know were there any errors or not :-). Run the following commands to:"
echo
echo "Build click package :: 'cd seabass-$APP_VERSION; cordova build --device'"
echo "Build & run on connected device :: 'cd seabass-$APP_VERSION; cordova run --device'"
echo "Build & run in Debug mode on connected device :: 'cd seabass-$APP_VERSION; cordova run --device --debug'"
echo "Build & install .deb package :: '(cd seabass-$APP_VERSION; cordova build ubuntu; cd platforms/ubuntu/native/seabass.mikhael; debuild -uc -us; sudo dpkg -i ../seabass.mikhael_${APP_VERSION}_amd64.deb )'"

echo
echo "*** Preparing apparmor manifest ***"
echo "You might want to patch Cordova's manifest.js file to build unconfined version of the app"
echo "see https://github.com/milikhin/seabass/blob/master/building.md#31-patch-for-an-unconfined-version for more info..."
echo 
