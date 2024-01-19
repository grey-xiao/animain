part of 'anime_bloc.dart';

sealed class AnimeEvent extends Equatable {
  const AnimeEvent();

  @override
  List<Object> get props => [];
}

class LoadAnime extends AnimeEvent {
  final List<Anime> animes;

  const LoadAnime({this.animes = const <Anime>[]});

  @override
  List<Object> get props => [animes];
}

class AddAnime extends AnimeEvent {
  final Anime anime;

  const AddAnime({required this.anime});

  @override
  List<Object> get props => [anime];
}

class UpdateAnime extends AnimeEvent {
  final Anime anime;

  const UpdateAnime({required this.anime});

  @override
  List<Object> get props => [anime];
}

class DeleteAnime extends AnimeEvent {
  final Anime anime;

  const DeleteAnime({required this.anime});

  @override
  List<Object> get props => [anime];
}