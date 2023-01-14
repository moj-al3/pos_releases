#!/bin/bash

LINE="=============================================="
FLUTTER_APP_PATH="C:\Users\mojtaba\Documents\Flutter\pos_mobile\code"
RELEASE_PATH="C:\Users\mojtaba\Documents\Flutter\pos_mobile\Release" 
FLUTTER_APP_VERSION_PATH="C:\Users\mojtaba\Documents\Flutter\pos_mobile\code\lib\core\controller\update_controller.dart"
VERSION_JSON_PATH=$RELEASE_PATH"\version.json"
INSTALLER_SCRIPT_PATH=$RELEASE_PATH"\script.iss"
RELEASE_BUILD_PATH=$RELEASE_PATH"\build"
RELEASE_EFATORAA_INSTALLER_PATH=$RELEASE_PATH"\EFATORAA_INSTALLER.exe"


echo "Task: Get the new version"
NEW_VERSION=$(cat $FLUTTER_APP_VERSION_PATH | grep -o 'double currentVersion =.*' | grep -o -E '[0-9.]+');
echo $NEW_VERSION
echo $LINE


echo "Task: Remove the old build data from the installer"
rm -r $RELEASE_BUILD_PATH
rm $RELEASE_EFATORAA_INSTALLER_PATH
echo $LINE

echo "Task: Building the app files"
cd $FLUTTER_APP_PATH
flutter build windows
echo $LINE

echo "Task: Copy the new build data to the installer DIR"
cp -R $FLUTTER_APP_PATH"\build\windows\runner\Release" $RELEASE_BUILD_PATH
echo $LINE



echo "Task: Update the version of the installer and json"
sed -i 's/#define MyAppVersion ".*"/#define MyAppVersion "'$NEW_VERSION'"/g' $INSTALLER_SCRIPT_PATH
sed -i 's/"version": .*,/"version": '$NEW_VERSION',/g' $VERSION_JSON_PATH
echo $LINE

echo "Task: Build installer"
iscc.exe $INSTALLER_SCRIPT_PATH
echo $LINE

echo "Task: push the new version"
cd $RELEASE_PATH
git status
git add .
git commit -m "updated to version '$NEW_VERSION'"
git push
echo $LINE
read -p "Press enter to continue"