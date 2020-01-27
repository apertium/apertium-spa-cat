#!/usr/bin/env python3
#
# Copyright (C) 2020 Jaume Orotlà <jaume.ortola@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#

import sys, re
import xml.etree.ElementTree as ET

source = sys.argv[1]
target = sys.argv[2]

tree = ET.ElementTree()
tree.parse(source)

pardefs = tree.find('pardefs')

prefixes = {}

for pardef in pardefs.iter(tag='pardef'):
    namepardef = pardef.get("n")
    if namepardef.startswith("prefixes_"):
        grammarclass = re.sub ("prefixes_([^_]+).*", "\\1", namepardef)
        prefixes[grammarclass]=namepardef

mainsection = tree.find('.//section[@id="main"]')

for e in mainsection.iter(tag='e'):
    parname = ""
    par = None
    p = e.find('p')
    if p:
        par = p.find('l').find('s')
    if par is None:
        i = e.find('i')
        if i:
            par = i.find('s')
    if par is None:
        continue
    parname = par.get("n")
    for prefix in prefixes.keys():        
        if parname == prefix:
            new = ET.Element('par')
            new.set('n', prefixes[prefix])
            e.insert(0, new)

tree.write(target)