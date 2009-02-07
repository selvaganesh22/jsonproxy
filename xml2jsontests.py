#!/usr/bin/env python

import unittest
import xml2json
import xml.dom.minidom


class Xml2JsonTestCase(unittest.TestCase):

  def _AssertXmlMatchesJson(self, xml_string, json_string):
    doc = xml.dom.minidom.parseString(xml_string)
    gen_json = xml2json.DocumentToJson(doc)

    print 'src_json:', json_string
    print 'gen_json:', gen_json
    self.assertEqual(json_string, gen_json,
        'JSON strings expected to match.\nsrc:%s\ngen:%s' %
                     (json_string, gen_json))
  
  def testSimpleAttribute(self):
    self._AssertXmlMatchesJson(
        '<foo key="value"></foo>',
        '{"foo": {"@key": "value"}}')

  def testSingleNestedTag(self):
    self._AssertXmlMatchesJson(
        '<foo>bar</foo>',
        '{"foo": {"$": "bar"}}')

  # These are the BadgerFish examples.
  # See http://badgerfish.ning.com/

  def testTextContent(self):
    self._AssertXmlMatchesJson(
        '<alice>bob</alice>',
        '{"alice": {"$": "bob"}}')

  def testNestedElements(self):
    self._AssertXmlMatchesJson(
        '<alice><bob>charlie</bob><david>edgar</david></alice>',
        '{"alice": {"bob": {"$": "charlie"}, "david": {' +
        '"$": "edgar"}}}')

  def testAttribute(self):
    self._AssertXmlMatchesJson(
        '<alice charlie="david">bob</alice>',
        '{"alice": {"$": "bob", "@charlie": "david"}}')


if __name__ == "__main__":
  unittest.main()
    
