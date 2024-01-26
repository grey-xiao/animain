
import 'package:animain/controller/xml_query_controller.dart';
import 'package:animain/database/database_service.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';


class AnimeController {
  Map<String?, String?> queries = {};

  //AnimeController({required this.queries});

  Future<String> loadQuery(String query) async{
    queries = await XMLQuery().getQueriesFromXML();
    return queries[query]!;
  }

  Future<int> insert({required String title, required String description, required int episodes}) async {
    bool notDuplicate = await checkDuplicate(title);
    if(notDuplicate){
      final database = await DatabaseService().database;

      int id = await database.rawInsert(
        await loadQuery(queryNames[0]),
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
      await loadQuery(queryNames[1]),
    );
    return animeList.map((anime) => Anime.fromSqfliteDatabase(anime)).toList();
  }

  Future<Anime> fetchById(int id) async {
    final database = await DatabaseService().database;
    final anime = await database.rawQuery(
      await loadQuery(queryNames[2]),
      [id]
    );
    return Anime.fromSqfliteDatabase(anime.first);
  }

  Future<bool> checkDuplicate(String? title)  async{
    final database = await DatabaseService().database;
    final animeList = await database.rawQuery(
      await loadQuery(queryNames[3]),
      [title]
    );
    return animeList.first.containsValue(0);
  }

  Future<int> update({required int id, String? title, String? description, int? episodes}) async {
    bool notDuplicate = await AnimeController().checkDuplicate(title);
    if(notDuplicate){
      final database = await DatabaseService().database;
      return await database.rawUpdate(
        await loadQuery(queryNames[4]),
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
      await loadQuery(queryNames[5]),
      [id]
    );
  }
  Future<void> deleteAll() async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      await loadQuery(queryNames[6]),
    );
  }
}