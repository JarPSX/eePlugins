#!/bin/bash
myPath=$(dirname $0)
myAbsPath=$(readlink -fn "$myPath")

destE2iplayerPath=usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer

e2iplayerGTIs=/enigma2-pc/e2iplayerGITsSources

cd $e2iplayerGTIs
############################## Syncing GITLAB ##############################
for mydir in `find -type d`
do
 if [ -e $mydir/.git ] ; then
  echo $mydir
  cd $mydir
  git pull
  if [ $? -gt 0 ];then
    echo "Error puling fresh git data. END"
    exit 1
  fi
  cd $e2iplayerGTIs
 fi
done
############################## Copying master git ##############################
cd $myAbsPath/../../Se2iP
if [ $? -gt 0 ];then
  echo "wrong path"
  exit 1
fi
rm -rf usr/*
mkdir -p $destE2iplayerPath
cp -rf $e2iplayerGTIs/SSS/e2iplayer/IPTVPlayer/* $destE2iplayerPath
############################## Copying & patching pycurl install script ##############################
cp -rf $e2iplayerGTIs/SSS/www.iptvplayer.gitlab.io/pycurlinstall.py iptvplayer_rootfs/

############################## Copying additional hosts ##############################

exit 0 
publicGitRoot=$GITroot/crossplatform_iptvplayer
daemonDir=$publicGitRoot/IPTVdaemon
KaddonDir=$publicGitRoot/addon4KODI/neutrinoIPTV
NpluginDir=$publicGitRoot/addon4neutrino/neutrinoIPTV
publicGitDir=$publicGitRoot/IPTVplayer

############################## Syncing GITLAB ##############################
if [ ! -d ~/Archive/iptvplayer-GitLab-master-version ];then
  mkdir -p ~/Archive
  echo 'Cloning...'
  git clone https://gitlab.com/iptvplayer-for-e2/iptvplayer-for-e2.git ~/Archive/iptvplayer-GitLab-master-version
else
  echo 'Syncing GitLab...'
  cd ~/Archive/iptvplayer-GitLab-master-version
  git pull
fi
if [ ! -d ~/Archive/iptvplayerXXX-GitLab-master-version ];then
  echo 'Cloning XXX host...'
  git clone https://gitlab.com/iptv-host-xxx/iptv-host-xxx.git ~/Archive/iptvplayerXXX-GitLab-master-version
else
  echo 'Syncing GitLab XXX host...'
  cd ~/Archive/iptvplayerXXX-GitLab-master-version
  git pull
fi
if [ ! -d ~/Archive/iptvplayer-infoversion-host ];then
  echo 'Cloning XXX host...'
  git clone https://gitlab.com/mosz_nowy/infoversion.git ~/Archive/iptvplayer-infoversion-host
else
  echo 'Syncing GitLab XXX host...'
  cd ~/Archive/iptvplayer-infoversion-host
  git pull
fi
if [ ! -d ~/Archive/zdzislaw-iptvplayer-GitLab-version ];then
  mkdir -p ~/Archive
  echo 'Cloning...'
  git clone https://gitlab.com/zdzislaw22/iptvplayer-for-e2.git ~/Archive/zdzislaw-iptvplayer-GitLab-version
else
  echo 'Syncing Zdzislaw22 version...'
  cd ~/Archive/zdzislaw-iptvplayer-GitLab-version
  git pull
fi
############################## Syncing neutrinoIPTV ##############################
echo 'Syncing neutrinoIPTV...'
cd ~/Archive/iptvplayer-GitLab-master-version/

subDIR='components'
  [ -e $publicGitDir/i$subDIR ] && rm -rf $publicGitDir/i$subDIR/* || mkdir -p $publicGitDir/i$subDIR
  cp -a ~/Archive/iptvplayer-GitLab-master-version/IPTVPlayer/$subDIR/* $publicGitDir/i$subDIR
subDIR='tools'
  [ -e $publicGitDir/i$subDIR ] && rm -rf $publicGitDir/i$subDIR/* || mkdir -p $publicGitDir/i$subDIR
  cp -a ~/Archive/iptvplayer-GitLab-master-version/IPTVPlayer/$subDIR/* $publicGitDir/i$subDIR

  rm -rf $publicGitDir/ihosts

subDIRs="cache icons/logos hosts iptvdm libs locale"
for subDIR in $subDIRs
do
  [ -e $publicGitDir/$subDIR ] && rm -rf $publicGitDir/$subDIR/* || mkdir -p $publicGitDir/$subDIR
  cp -a ~/Archive/iptvplayer-GitLab-master-version/IPTVPlayer/$subDIR/* $publicGitDir/$subDIR
done

subDIRs="icomponents itools hosts libs scripts iptvdm"
for subDIR in $subDIRs
do
  #ln -sf ../__init__.py $publicGitDir/$subDIR/__init__.py
  touch $publicGitDir/$subDIR/__init__.py
done
cp -a ~/Archive/iptvplayerXXX-GitLab-master-version/IPTVPlayer/hosts/* $publicGitDir/hosts/
cp -a ~/Archive/iptvplayer-infoversion-host/hosts/* $publicGitDir/hosts/
cp -f ~/Archive/iptvplayer-GitLab-master-version/IPTVPlayer/version.py $publicGitDir
wersja=`cat ./IPTVPlayer/version.py|grep 'IPTV_VERSION='|cut -d '"' -f2`
sed -i "s/^name=.*$/name=IPTV for Neutrino @j00zek v.$wersja/" $NpluginDir/neutrinoIPTV.cfg
sed -i "s/^name.polski=.*$/name.polski=IPTV dla Neutrino @j00zek w.$wersja/" $NpluginDir/neutrinoIPTV.cfg
echo "$wersja">$daemonDir/version
############################## logos structure & names ##############################
rm -f $publicGitDir/icons/*
mv -f $publicGitDir/icons/logos/*.png $publicGitDir/icons/
cp -a ~/Archive/iptvplayerXXX-GitLab-master-version/IPTVPlayer/icons/logos/XXXlogo.png $publicGitDir/icons/XXX.png
cp -a ~/Archive/iptvplayer-infoversion-host/icons/logos/infologo.png $publicGitDir/icons/infoversion.png
rm -rf $publicGitDir/icons/logos/
rm -rf $publicGitDir/icons/favourites*
cd $publicGitDir/icons/
for myfile in `ls ./*logo.png`
do
  newName=`echo $myfile|sed 's/logo//'`
  mv -f $myfile $newName
done
############################## hosts names ##############################
cd $publicGitDir/hosts/
rm -f ./list.txt
for myfile in `ls ./*.py`
do
  newName=`echo $myfile|sed 's/host//'`
  [ $myfile == $newName ] || mv -f $myfile $newName
done
############################## Adapt congig.py file ##############################
myFile=$publicGitDir/icomponents/iptvconfigmenu.py
sed -i 's/import ConfigBaseWidget,/import/' $myFile
sed -i '/class ConfigMenu(ConfigBaseWidget)/,$d' $myFile
#remove unnecesary stuff
sed -i 's;from iptvpin import IPTVPinWidget;;g
  
  ' $myFile
#own settings
sed -i 's;\(^.*ListaGraficzna.*default[ ]*=[ ]*\)True\(.*$\);\1False\2; 
  s;\(^.*showcover.*default[ ]*=[ ]*\)True\(.*$\);\1False\2; 
  s;\(^.*autoCheckForUpdate.*default[ ]*=[ ]*\)True\(.*$\);\1False\2; 
  s;\(^.*wgetpath.*default = \)"";\1"wget"; 
  s;\(^.*f4mdumppath.*default = \)"";\1"f4mdump"; 
  s;\(^.*rtmpdumppath.*default = \)"";\1"rtmpdump"; 
  s;\(^.*dukpath.*default = \)"";\1"duk"; 
  s;\(^.*hlsdlpath.*default = \)"";\1"hlsdl"; 
  ' $myFile

############################## cleaning unused components #######################################################################################
echo 'Cleaning not used components from scripts...'
cd $publicGitDir
for myfile in `find -type f -name '*.py'`
do
  #echo $myfile
  
  sed -i "s;\(from .*\.\)components\(\.iptvplayerinit\);\1dToolsSet\2;g" $myfile #use own fake initscript
  sed -i "s;\(from .*\.\)tools\(\.iptvtools\);\1dToolsSet\2;g" $myfile #use own fake tools script
  sed -i "s;\(from .*\.\)components\.recaptcha_v2widget;\1dToolsSet.recaptcha_v2widget;g" $myfile #use own fake capcha
  toDel='MessageBox';[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='ConfigBaseWidget';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='ConfigHostsMenu';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='IPTVDirectorySelectorWidget';	[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='IPTVSetupMainWidget';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='Screen';			[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='VirtualKeyBoard';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='Label';			[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='ConfigListScreen';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='boundFunction';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='IPTVUpdateWindow';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='ActionMap';			[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='ConfigExtMoviePlayer';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  toDel='IPTVMultipleInputBox';		[[ `grep -c $toDel<$myfile` -gt 1 ]] || sed -i "/import .*$toDel/d" $myfile
  #toDel='self.console_appClosed_conn';	[[ `grep -q $toDel<$myfile` ]] || sed -i "/$toDel/d" $myfile
  #toDel='self.console_stderrAvail_conn';[[ `grep -q $toDel<$myfile` ]] || sed -i "/$toDel/d" $myfile
  
  #adding missing
  toAdd='iptvplayerinit import TranslateTXT as _';         [[ `grep -c "$toAdd"<$myfile` -ge 1 ]] || sed -i "/ihost import IHost/a from Plugins.Extensions.IPTVPlayer.dToolsSet.iptvplayerinit import TranslateTXT as _" $myfile
  
  #probably to del later ;)
  #toDel='eConsoleAppContainer';		[[ `grep -c $toDel<$myfile` -ge 1 ]] && echo $myfile #sed -i "s/\(^.*$toDel\)/#\1/g" $myfile
  sed -i 's/\(raise BaseException\)("\(.*\)")/printDBG("\1(\2)")/g' $myfile
  #sed -i "s/\(getListForItem begin\)\(['\"]+\)/\1 Index=%d, selItem=%s \2 % (Index,str(selItem))/g" $myfile

  # NEW folders structure
  sed -i "s;\(from .*\.\)components\(.*\);\1icomponents\2;g" $myfile #new folders structure to workarround with fat issues
  sed -i "s;\(from .*\.\)tools\(.*\);\1itools\2;g" $myfile #new folders structure to workarround with fat issues
  sed -i "s;\(import .*\.\)components\(.*\);\1icomponents\2;g" $myfile #new folders structure to workarround with fat issues
  sed -i "s;\(import .*\.\)tools\(.*\);\1itools\2;g" $myfile #new folders structure to workarround with fat issues
  sed -i "s;\(import .*\dToolsSet.\)itools\(.*\);\1iptvtools\2;g" $myfile #new folders structure to workarround with fat issues
  sed -i "s;getDesktop(0).size().width();1980;g" $myfile #e2 emulator does not have it, so setting 1980 FHD it eill br nrvrt used
done
#removing local imports from the list
echo 'Removing some hosts and adding couple new 3rd party...'
cd $publicGitDir

#specific for hosts
sed -i "s/\(_url.*hostXXX.py\)/\1DISABLED/g" $publicGitDir/hosts/XXX.py
############################## Syncing contrib apps ##############################
#echo 'Syncing contrib apps...'
#wget -q http://iptvplayer.pl/resources/bin/sh4/exteplayer3_ffmpeg3.0 -O $publicGitDir/bin/sh4/exteplayer3
#wget -q http://iptvplayer.pl/resources/bin/sh4/uchardet -O $publicGitDir/bin/sh4/uchardet

############################## Delete some unwanted hosts ##############################
cd $publicGitDir
#step 1 remove all definitevely unwanted
HostsList='anime chomikuj favourites disabled blocked localmedia wolnelekturypl urllist iptvplayerinfo'
for myfile in $HostsList
do
  rm -rf ./hosts/*$myfile*
  rm -rf ./icons/*$myfile*
done

############################## Delete hosts with captcha ##############################
cd $publicGitDir/hosts
for myfile in `find -type f -name '*.py'`
do
  toDel='captcha';
  if [[ `grep -c $toDel<$myfile` -ge 1 ]];then 
    rm -rf $publicGitDir/hosts/*$myfile*
    rm -rf $publicGitDir//icons/*$myfile*
    echo "deleting captcha host: $myfile"
  fi
done

###change some default values
sed -i "s;\(config\.plugins\.iptvplayer\.\iplaUseDF.*ConfigYesNo.default[ ]*=[ ]*\)True;\1False;" $publicGitDir/hosts/ipla.py
############################## copying to GIT public repo to fit license ##############################
#echo 'Syncing public GIT...'
#cp -a $publicGitDir/* $GITroot/cmdline_iptvplayer/
#rm -rf $GITroot/cmdline_iptvplayer/dToolsSet
#rm -f $GITroot/cmdline_iptvplayer/IPTVdaemon.py
#rm -f $GITroot/cmdline_iptvplayer/testcmdline.py
#rm -f $GITroot/cmdline_iptvplayer/cmdlineIPTV.py

###################### step 2 create lua list with titles
cd $publicGitDir
echo "HostsList={ ">$NpluginDir/luaScripts/hostslist.lua
echo "# -*- coding: utf-8 -*-
HostsList=[ ">$daemonDir/dToolsSet/hostslist.py
for myfile in `cd ./hosts;ls ./*.py|grep -v '_init_'|sort -fi`
do
    fileNameRoot=`echo $myfile|sed 's/\.\/\(.*\)\.py/\1/'`
    tytul=`sed -n '/def gettytul..:/ {n;p}' ./hosts/$myfile`
    if `grep -v '[ \t]*#'< ./hosts/$myfile|grep -q 'optionList\.append(getConfigListEntry('`;then
	hasConfig=1
    else
	hasConfig=0
    fi
    if ! `echo $tytul|grep -q 'return'`;then
      tytul=$fileNameRoot
    else
      #tytul=`echo $tytul|cut -d "'" -f2|sed "s;http://;;"|sed "s;/$;;"|sed "s;www\.;;"`
      tytul=`echo $tytul|sed "s/^.*['\"]\(.*\)['\"].*$/\1/"|sed 's/^ *//;s/ *$//;s/http[s]*://;s/\///g;s/www\.//'`
    fi
    #echo "	{id=\"$fileNameRoot\", title=\"$tytul\", fileName=\"hosts/$fileNameRoot.py\", logoName=\"icons/$fileNameRoot.png\", type=\"py\"},">>$NpluginDir/luaScripts/hostslist.lua
    echo "      {id=\"$fileNameRoot\", title=\"$tytul\", type=\"py\"},">>$NpluginDir/luaScripts/hostslist.lua
    echo "	(\"$fileNameRoot\", \"$tytul\"),">>$daemonDir/dToolsSet/hostslist.py
done
echo "	]">>$daemonDir/dToolsSet/hostslist.py
##################### step 3 the same for lua scripts
cd $NpluginDir
for myfile in `cd ./luaHosts;ls ./*.lua|sort -fi`
do
    fileNameRoot=`echo $myfile|sed 's/\.\/\(.*\)\.lua/\1/'`
    tytul=`sed -n '/def gettytul..:/ {n;p}' ./luaHosts/$myfile`
    if ! `echo $tytul|grep -q 'return'`;then
      tytul=$fileNameRoot
    else
      tytul=`echo $tytul|cut -d "'" -f2|sed "s;http://;;"|sed "s;/$;;"|sed "s;www\.;;"`
    fi
    echo "	{id=\"$fileNameRoot\", title=\"$tytul\", fileName=\"luaHosts/$fileNameRoot.lua\", logoName=\"luaHosts/$fileNameRoot.png\", type=\"lua\"},">>$NpluginDir/luaScripts/hostslist.lua
done
echo "	}">>$NpluginDir/luaScripts/hostslist.lua
###################### step 4 create list of possible configs
cd $publicGitDir
echo "#Aby ustawic jakas opcje nalezy skopiowac jej nazwe do pliku E2settings.conf i wpisac jej wartosc" > $NpluginDir/../IPTV-E2settings.list
echo "#Przyklad:" >> $NpluginDir/../IPTV-E2settings.list
echo "" >> $NpluginDir/../IPTV-E2settings.list
echo "#Lista mozliwych opcji konfiguracyjnych IPTVplayer-a:" >> $NpluginDir/../IPTV-E2settings.list
for myfile in `find -type f -name '*.py'`
do
  #echo $myfile
  cat $myfile| egrep -v 'extplayer|gstplayer|MIPS|ARM|software_decode' | grep -o "config\.plugins\.iptvplayer\..*=[ ]*Config.*$" >> $NpluginDir/../IPTV-E2settings.list
done
