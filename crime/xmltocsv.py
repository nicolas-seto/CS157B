import sys
import os.path
import xml.etree.ElementTree as etree

if len(sys.argv) < 2:
    sys.exit('Usage: %s <xml-file>' % sys.argv[0])

if not os.path.isfile(sys.argv[1]):
    sys.exit('Error: %s was not found.' % sys.argv[1])

tree = etree.parse(sys.argv[1])
root = tree.getroot()

name_split = [sys.argv[1][:-3],'csv']
name = ''.join(name_split)

f = open(name, 'w')
i = 0

for child in root:
    attributes = child.attrib
    if i == 0:
        keys = list(attributes.keys())
        keys.append(child.tag)
        fields = '","'.join(keys)
        f.write('"')
        f.write(fields)
        f.write('"')
        f.write('\n')
    values = list(attributes.values())
    values.append(child.text)
    #for j in range(len(values)):
        #values[j] = values[j].replace(',', ';')
    fields = '","'.join(values)
    f.write('"')
    f.write(fields)
    f.write('"')
    f.write('\n')
    i += 1

f.close()