part of 'anime_bloc.dart';

sealed class AnimeState extends Equatable {
  const AnimeState();
  
  @override
  List<Object> get props => [];
}

final class AnimeLoading extends AnimeState {}

class AnimeLoaded extends AnimeState {
  final List<Anime> animes;
  
  const AnimeLoaded({this.animes = const <Anime>[]});

  @override
  List<Object> get props => [animes];
}

