import 'package:animain/util/strings.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;

class XMLQuery {
  Future<Map<String?, String?>> getQueriesFromXML() async {
    Map<String?, String?> queries = {};
    var xmlString =  await rootBundle.loadString(xmlQueryString);
    
    var raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements('query');

    for (var element in elements) { 
      final item = {element.getAttribute('name'): element.firstChild.toString()};
      queries.addEntries(item.entries);
    }
    return  queries;
    
  }
}