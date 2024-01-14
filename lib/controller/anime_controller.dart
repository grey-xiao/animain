
import 'package:animain/database/database_service.dart';
import 'package:animain/model/anime_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;

class AnimeController {
  final tableName = 'anime';

  Map<String?, String?> queries = {};


  void getQueriesFromXML(BuildContext context) async {
    String xmlString = await DefaultAssetBundle.of(context).loadString('assets/data/db_queries.xml');

    var raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements('query');

    for (var element in elements) { 
      final item = {element.getAttribute('name'): element.firstChild.toString()};
      queries.addEntries(item.entries);
    }
  }

  String loadQuery(String query){
    return queries[query]!;
    //return queries.values.firstWhere((element) => element!.contains(query)).toString();
  }

  Future<void> createTable(Database database) async {
      await database.execute(
        loadQuery('create'),
        [tableName]
    );
  }

  Future<int> insert({required String title, required String description, required int episodes}) async {
    bool notDuplicate = await checkDuplicate(title);
    if(notDuplicate){
      final database = await DatabaseService().database;

      int id = await database.rawInsert(
        loadQuery('insert'),
        [title, description, episodes],
      );
      return id;
    }
    else{
      return 0;
    }
  }

  Future<List<Anime>> fetchAll() async {
    final database = await DatabaseService().database;
    final animeList = await database.rawQuery(
      loadQuery('selectAll'),
    );
    return animeList.map((anime) => Anime.fromSqfliteDatabase(anime)).toList();
  }

  Future<Anime> fetchById(int id) async {
    final database = await DatabaseService().database;
    final anime = await database.rawQuery(
      loadQuery('select'),
      [id]
    );
    return Anime.fromSqfliteDatabase(anime.first);
  }

  Future<bool> checkDuplicate(String? title)  async{
    final database = await DatabaseService().database;
    final animeList = await database.rawQuery(
      loadQuery('checkDuplicate'),
      [title]
    );
    return animeList.first.containsValue(0);
  } 

  ////If SQLite syntax, not using raw Query
  // Future<int> update({required int id, String? title, String? description, int? episodes}) async {
  //   bool notDuplicate = await checkDuplicate(title);
  //   if(notDuplicate){
  //     final database = await DatabaseService().database;
  //     return await database.update(
  //       tableName, 
  //       {
  //         'title': title,
  //         'description': description,
  //         'episodes': episodes,

  //       },
  //       where: 'id = ?',
  //       conflictAlgorithm: ConflictAlgorithm.rollback,
  //       whereArgs: [id],
  //     );
  //   }
  //   //failed
  //   else{
  //     return 0;
  //   }
    
  // }

  Future<int> update({required int id, String? title, String? description, int? episodes}) async {
    bool notDuplicate = await checkDuplicate(title);
    if(notDuplicate){
      final database = await DatabaseService().database;
      return await database.rawUpdate(
        loadQuery('update'),
        [title, description, episodes, id]
      );
    }
    //failed
    else{
      return 0;
    }
    
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      loadQuery('delete'),
      [id]
    );
  }
  Future<void> deleteAll() async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      loadQuery('deleteAll'),
    );
  }
}