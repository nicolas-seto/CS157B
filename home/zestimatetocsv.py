import os
import sys
import xml.etree.ElementTree as etree

FOLDER = 'zestimates'
DIR = os.getcwd()
NEW_DIR = os.path.join(DIR, FOLDER)
new_file = os.path.join(DIR, 'homeData.csv')
files = [ os.path.join(NEW_DIR, file) for file in os.listdir(NEW_DIR) ]

f = open(new_file, 'w')
f.write('zpid,street,zipcode,city,state,latitude,longitude,amount,lowAmount,highAmount,percentile\n')

for file in files:
    aList = []
    tree = etree.parse(file)
    root = tree.getroot()
    message = root[1]
    if int(message[1].text) != 0:
        continue
    else:
        response = root[2]
        for child in response:
            if child.tag == 'zpid':
                aList.append(child.text)
            elif child.tag == 'address':
                newDict = [ aChild.text for aChild in list(child) ]
                aList.extend(newDict)
            elif child.tag == 'zestimate':
                aList.append(child[0].text)
                valuationRange = child[4]
                aList.append(valuationRange[0].text)
                aList.append(valuationRange[1].text)
                aList.append(child[5].text)
        newList = [ '' if elem is None else elem for elem in aList ]
        fields = ','.join(newList)
        f.write(fields)
        f.write('\n')

f.close()