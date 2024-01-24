part of 'anime_bloc.dart';

abstract class AnimeState extends Equatable {
  const AnimeState();
  
  @override
  List<Object> get props => [];
}

final class AnimeLoading extends AnimeState {}

class AnimeListLoaded extends AnimeState {
  final List<Anime> animes;
  
  const AnimeListLoaded({required this.animes});

  @override
  List<Object> get props => [animes];
}
class AnimeSearchLoaded extends AnimeState {
  final List<Anime> animes;
  
  const AnimeSearchLoaded({required this.animes});

  @override
  List<Object> get props => [animes];
}

class AnimeLoaded extends AnimeState {
  final Anime anime;
  
  const AnimeLoaded({required this.anime});

  @override
  List<Object> get props => [anime];
}


class AnimeRefreshing extends AnimeState {
  
}
