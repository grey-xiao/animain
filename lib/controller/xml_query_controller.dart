import 'package:animain/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

class XMLQuery {
  Future<Map<String?, String?>> getQueriesFromXML(BuildContext context) async {
    Map<String?, String?> queries = {};
    String xmlString = await DefaultAssetBundle.of(context).loadString(xmlQueryString);

    var raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements('query');

    for (var element in elements) { 
      final item = {element.getAttribute('name'): element.firstChild.toString()};
      queries.addEntries(item.entries);
    }
    return  queries;
  }
}