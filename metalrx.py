#!/usr/bin/python3

import sys
import xml.etree.ElementTree as ET
    
source = sys.argv[1]
target = sys.argv[2]

tree = ET.ElementTree()
tree.parse(source)

rules = tree.find('rules')

macros = []

for macro in tree.iter(tag='macro'):
	
	defmacro = tree.find('.//def-macro[@name="' + macro.attrib['name'] + '"]')
	
	macrostr = ET.tostring(defmacro, encoding="unicode")
	for k,v in macro.attrib.items():
		if k.startswith('p'):
			kstr = '{{' + k + '}}'
			macrostr = macrostr.replace(kstr, v)
	
	newtree = ET.fromstring('<root>' + macrostr + '</root>')
	
	for r in newtree.iter(tag='rule'):
		rules.append(r)
		
	macros.append(macro)

allmacrodefs = tree.getroot().find('def-macros')
print(allmacrodefs)
print("==============")
print(ET.tostring(tree.getroot()))

tree.getroot().remove(allmacrodefs)

for macro in macros:
	rules.remove(macro)


tree.write(target)
