#!/bin/bash


Cyan='\033[0;36m'
Default='\033[0;m'

projectName=""
httpsRepo=""
homePage=""
confirmed="n"

getProjectName() {
    read -p "请输入项目名: " projectName

    if test -z "$projectName"; then
        getProjectName
    fi
}

getHTTPSRepo() {
    read -p "请输入仓库HTTPS URL: " httpsRepo

    if test -z "$httpsRepo"; then
        getHTTPSRepo
    fi
}

getHomePage() {
    read -p "请输入主页 URL: " homePage

    if test -z "$homePage"; then
        getHomePage
    fi
}

getInfomation() {
    getProjectName
    getHTTPSRepo
    getHomePage

    echo -e "\n${Default}================================================"
    echo -e "  Project Name       :  ${Cyan}${projectName}${Default}"
    echo -e "  HTTPS Repo         :  ${Cyan}${httpsRepo}${Default}"
    echo -e "  Home Page URL      :  ${Cyan}${homePage}${Default}"
    echo -e "================================================\n"
}

echo -e "\n"
while [ "$confirmed" != "y" -a "$confirmed" != "Y" ]
do
    if [ "$confirmed" == "n" -o "$confirmed" == "N" ]; then
        getInfomation
    fi
    read -p "确定? (y/n):" confirmed
done

cd ..
pod lib create $projectName

specFilePath="../${projectName}/${projectName}.podspec"
uploadFilePath="../${projectName}/upload.sh"

cd config/
echo "copy to $specFilePath"
cp -f ./templates/pod.podspec  "$specFilePath"
echo "copy to $uploadFilePath"
cp -f ./templates/upload.sh    "$uploadFilePath"

echo "editing..."
sed -i "" "s%__ProjectName__%${projectName}%g" "$uploadFilePath"

sed -i "" "s%__ProjectName__%${projectName}%g" "$specFilePath"
sed -i "" "s%__HomePage__%${homePage}%g"      "$specFilePath"
sed -i "" "s%__HTTPSRepo__%${httpsRepo}%g"    "$specFilePath"

echo "edit finished"

echo "cleaning..."
cd ../$projectName
rm -rf .git
git init
git remote add origin $httpsRepo  &> /dev/null
git rm -rf --cached ./Pods/     &> /dev/null
git rm --cached Podfile.lock    &> /dev/null
git rm --cached .DS_Store       &> /dev/null
git rm -rf --cached $projectName.xcworkspace/           &> /dev/null
git rm -rf --cached $projectName.xcodeproj/xcuserdata/`whoami`.xcuserdatad/xcschemes/$projectName.xcscheme &> /dev/null
git rm -rf --cached $projectName.xcodeproj/project.xcworkspace/xcuserdata/ &> /dev/null
echo "clean finished"

say "finished"
echo "finished"
