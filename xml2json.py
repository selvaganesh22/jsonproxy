#!/usr/bin/env python
# Copyright 2009 Google Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import simplejson
import xml.dom


def DocumentToJson(document):
  return simplejson.dumps(DocumentToDict(document))


def DocumentToDict(document):
  dict_root = {}
  return _VisitNode(document, dict_root)


def _VisitNode(node, nodeDict):
  text = ''

  for child_node in node.childNodes:

    # Handle these nodes for now, perhaps special handling for others later.
    if (child_node.nodeType in [xml.dom.Node.TEXT_NODE,
                                xml.dom.Node.CDATA_SECTION_NODE]):
      text += child_node.data
    elif (child_node.nodeType in [xml.dom.Node.DOCUMENT_NODE,
                                  xml.dom.Node.ELEMENT_NODE]):
      tag_name = child_node.tagName

      # Make sure we have an array for this type.
      if not child_node.tagName in nodeDict:
        nodeDict[tag_name] = []

        child_node_dict = {}
        _VisitNode(child_node, child_node_dict)

        nodeDict[tag_name].append(child_node_dict)

  # collapse single tags
  for key in nodeDict.keys():
    if len(nodeDict[key]) == 1:
      nodeDict[key] = nodeDict[key][0]

  if node.attributes:
    for i in xrange(node.attributes.length):
      attr = node.attributes.item(i)
      nodeDict['@' + attr.localName] = attr.value

  if len(text):
    nodeDict['$'] = text

  return nodeDict
