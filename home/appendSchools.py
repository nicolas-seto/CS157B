import csv

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

with open('homeData.csv', 'rb') as homeFile:
    homeReader = csv.reader(homeFile, delimiter=',')
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
            range = streetNum.split()
            streetNum = range[0]
        # Set up POST parameters
        params = dict(stnum=streetNum, stname=streetName, suffix=streetType, ti='notti', operation='dosomething', submit='Look Up')