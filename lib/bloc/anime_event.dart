part of 'anime_bloc.dart';

sealed class AnimeEvent extends Equatable {
  const AnimeEvent();

  @override
  List<Object> get props => [];
}

class LoadAnimeList extends AnimeEvent {
  //final List<Anime> animes;


  //LoadAnimeList({this.animes = const <Anime>[]});

  //@override
  //List<Object> get props => [animes];
}

class LoadAnime extends AnimeEvent {
  final int id;

  const LoadAnime({required this.id});

  @override
  List<Object> get props => [id];
}


class AddAnime extends AnimeEvent {
  final String title;
  final String description;
  final int episodes;

  const AddAnime({required this.title, required this.description, required this.episodes});

  @override
  List<Object> get props => [title, description, episodes];
}

class UpdateAnime extends AnimeEvent {
  final int id;
  final String title;
  final String description;
  final int episodes;

  const UpdateAnime({required this.id, required this.title, required this.description, required this.episodes});

  @override
  List<Object> get props => [id, title, description, episodes];
}

class DeleteAnime extends AnimeEvent {
  final Anime anime;

  const DeleteAnime({required this.anime});

  @override
  List<Object> get props => [anime];
}