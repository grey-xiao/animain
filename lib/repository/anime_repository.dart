import 'package:animain/controller/anime_controller.dart';

class AnimeRepository{
  final ac = AnimeController();
  
  Future fetchAll() => ac.fetchAll();
  Future fetchById(int id) => ac.fetchById(id);
  
  Future insert(String title, String description, int episodes) => ac.insert(title: title, description: description, episodes: episodes);
  Future update(int id, String title, String description, int episodes) => ac.update(id: id, title: title, description: description,  episodes: episodes);
  Future delete(int id) => ac.delete(id);

  Future deleteAll(int id) => ac.deleteAll();
}