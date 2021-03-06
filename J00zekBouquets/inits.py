# -*- coding: utf-8 -*-
from version import Version
Info='@j00zek %s' % Version

#stale
PluginName = 'J00zekBouquets'
PluginGroup = 'Extensions'

#Paths
import os
from Tools.Directories import fileExists,resolveFilename, SCOPE_CURRENT_SKIN, SCOPE_PLUGINS
PluginFolder = PluginName
PluginPath = resolveFilename(SCOPE_PLUGINS, '%s/%s/' %(PluginGroup,PluginFolder))
SkinPath = resolveFilename(SCOPE_CURRENT_SKIN, '')

def getMultiFramework():
    if fileExists("/usr/lib/enigma2/python/Plugins/SystemPlugins/ServiceApp/serviceapp.so"):
        return [("4097", "standardowy gstreamer (root 4097)"),("5001", "ServiceApp gstreamer (root 5001)"), ("5002", "ServiceApp ffmpeg (root 5002)"),("1", "sprzętowy, jak SAT (root 1)")]
    else:
        return [("4097", "standardowy gstreamer (root 4097)"),("1", "sprzętowy, jak SAT (root 1)")]

#Pobieranie plikow
##################
import urllib2, os, sys

def pyCurl( url, fileName ):
    try:
        if fileExists(fileName):
            os.remove(fileName)
        webContent = urllib2.urlopen(url).read()
        with open(fileName, 'w') as f:
            f.write(webContent)
    except Exception, e:
        print "Exception: %s" % str(e)
