import csv
import re
import requests

streetEndings = {'Ave':'Av',
                'Blvd':'Bl',
                'Cir':'Cr',
                'Ct':'Ct',
                'Dr':'Dr',
                'Hl':'Hl',
                'Ln':'Ln',
                'Park':'Pk',
                'Pl':'Pl',
                'Place':'Pl',
                'Plz':'Pz',
                'Rd':'Rd',
                'St':'St',
                'Ter':'Tr',
                'Walk':'Wk',
                'Way':'Wy'
                }

sfURL = 'http://www.sfpublicschools.org/php/lookup.php'
fileName = 'homeData.csv'
newFile = 'homeDataAppended.csv'

with open(fileName, 'rb') as homeFile:
    homeReader = csv.reader(homeFile, delimiter=',')
    
    with open(newFile, 'w') as createdFile:
        createdFile.write('zpid,street,zipcode,city,state,latitude,longitude,amount,lowAmount,highAmount,percentile,elemSchool,midSchool\n')
        for row in homeReader:
            if row[0] == 'zpid':
                continue
            # The address is the second field in the csv file
            address = row[1]
            endIndex = -1
            # Remove optional identifiers
            if 'APT' in address:
                endIndex = address.find('APT') - 1
            elif 'UNIT' in address:
                endIndex = address.find('UNIT') - 1
            elif '#' in address:
                endIndex = address.find('#') - 1
            if endIndex != -1:
                address = address[:endIndex]
            
            addressTokens = address.split()
            size = len(addressTokens)
            
            streetNum = addressTokens[0]
            streetName = ' '.join(addressTokens[1:size - 1])
            streetType = streetEndings.get(addressTokens[size - 1])
            # Skip if there are only two parts to the street or the street type is not in the dict
            if (size == 2) or (streetType is None):
                continue
            elif '-' in streetNum:
                range = streetNum.split('-')
                streetNum = range[0]
            # Set up POST parameters
            params = dict(stnum=streetNum, stname=streetName, suffix=streetType, ti='notti', operation='dosomething', submit='Look Up')
            
            r = requests.post(sfURL, data=params)
            
            # Skip this address if the address was not found
            if 'SORRY, YOUR ADDRESS CANNOT BE FOUND!' in r.text:
                continue
            
            elementarySchool_match = re.search(r'target="_blank">((\w+|\s)*)</a> \(SCHOOL #', r.text)
            middleSchool_match = re.search(r'This school feeds into:<br /><b>((\w+|\s|-|\.)*)</b>', r.text)
            
            if elementarySchool_match is None:
                continue
            else:
                elementarySchool = elementarySchool_match.group(1)
            if middleSchool_match is None:
                middleSchool = ''
            else:
                middleSchool = middleSchool_match.group(1)
            
            middleSchool_error = 'The first choice school listed will be considered the middle school feeder for the 2014-15 school year.'
            
            if middleSchool == middleSchool_error:
                middleSchool = ''
            elif 'SCHOOL' in middleSchool:
                endIndex = middleSchool.find('SCHOOL') - 1
                middleSchool = middleSchool[:endIndex]
            
            elemList = [word[0].upper() + word[1:].lower() for word in elementarySchool.split()]
            elemList.append('Elementary')
            elementarySchool = ' '.join(elemList)
            
            middleSchool = ' '.join(word[0].upper() + word[1:].lower() for word in middleSchool.split())
            
            row.extend([elementarySchool, middleSchool, '\n'])
            
            createdFile.write(' '.join(row))