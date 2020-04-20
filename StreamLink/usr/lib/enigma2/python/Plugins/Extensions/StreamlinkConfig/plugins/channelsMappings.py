# -*- coding: utf-8 -*-
name2nameDict = {'telewizjawphd': 'wp'}

name2service4wpDict = { 'Telewizja WP HD':      '1:0:1:3D5A:2C88:13E:820000:0:0:0',
                        'TVP 1 HD':             '1:0:1:3ABD:514:13E:820000:0:0:0',
                        'TVP 2 HD':             '1:0:1:C22:1E78:71:820000:0:0:0',
                        'Polsat':               '1:0:16:3:2:2268:EEEE0000:0:0:0',
                        'TVN':                  '1:0:1:3DCD:640:13E:820000:0:0:0',
                        'TV 4':                 '1:0:1:3393:3390:71:820000:0:0:0',
                        'TV Puls':              '1:0:1:3D66:2C88:13E:820000:0:0:0',
                        'TVP Warszawa':         '1:0:1:113B:2AF8:13E:820000:0:0:0',
                        'TVP Gdańsk':           '1:0:1:113B:2AF8:13E:820000:0:0:0',
                        '4FUN.TV':              '1:0:1:428D:2BC0:13E:820000:0:0:0',
                        '4FUN DANCE':           '1:0:1:428F:2BC0:13E:820000:0:0:0',
                        '4FUN GOLD':            '1:0:1:428E:2BC0:13E:820000:0:0:0',
                        'Travelxp HD':          '1:0:1:11FB:2B5C:13E:820000:0:0:0',
                        'Gametoon HD':          '1:0:1:38:16:A4A:0:0:0:0',
                        'Stars.TV HD':          '1:0:1:427F:2BC0:13E:820000:0:0:0',
                        'Music Box UA HD':      '1:0:1:A0:1C:224:0:0:0:0',
                        'Fashion TV HD':        '1:0:1:DFA:1AF4:FBFF:820000:0:0:0',
                        'France 24 HD':         '1:0:1:327:3BC4:13E:820000:0:0:0',
                        'France 24 English HD': '1:0:1:328:3BC4:13E:820000:0:0:0',
                        'To!TV':                '1:0:16:10E8:3E8:13E:820000:0:0:0',
                        'wPolsce.pl HD':        '1:0:1:4279:2BC0:13E:820000:0:0:0',
                        'Love TV HD':           '1:0:1:36:F8:63B2:0:0:0:0',
                        'TVS':                  '1:0:1:3D58:2C88:13E:820000:0:0:0',
                        'TV Trwam':             '1:0:1:10D6:418:1:C00000:0:0:0',
                        'Red Carpet TV HD':     '1:0:1:DB5:2D50:13E:820000:0:0:0',
                        'Polonia 1':            '1:0:1:423C:3DB8:13E:820000:0:0:0',
                        'Tele 5 HD':            '1:0:1:423B:3DB8:13E:820000:0:0:0',
                        'TBN Polska HD':        '1:0:1:327:1:1:82B00F:0:0:0'
                      }

name2serviceDict = {}

def updateDict():
    global name2serviceDict
    with open('/etc/enigma2/bouquets.tv','r') as btv:
        for bf2 in btv:
            if bf2.startswith('#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET'):
                bf2 = bf2.split('"')[1]
                with open('/etc/enigma2/' + bf2,'r') as bf3:
                    for line in bf3:
                        if line.startswith('#SERVICE ') and '::' in line: #this excludes every url links
                            mdata = line.strip().replace('#SERVICE ','').split('::')
                            if len(mdata[1]) > 3 and not name2serviceDict.get(mdata[1], False):
                                name = mdata[1].lower().replace(' ','')
                                name2serviceDict[name] = mdata[0]
                                if name.endswith('hd'):
                                    name2serviceDict[name[:-2]] = mdata[0]
    name2serviceDict['updatedDict'] = True


if name2serviceDict.get('updatedDict', False) == False:
    updateDict()

if __name__ == '__main__':
    for item in name2serviceDict:
        print("Key: '{}' , Referencja: '{}'".format(item,name2serviceDict[item]))
        