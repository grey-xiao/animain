import 'dart:async';
import 'dart:developer';
import 'package:animain/model/anime_model.dart';
import 'package:animain/repository/anime_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  static List<Anime> _animes = [];
  List<Anime> get animes => _animes;
  final animeRepo = AnimeRepository();
  static bool _searchMode = false;
  bool get searchMode => _searchMode;
  

  AnimeBloc() : super(AnimeLoading()) {
    on<LoadAnimeList>(_onLoadAnimeList);
    on<SearchAnime>(_onSearchAnime);
    on<SearchAnimeToggle>(_onSearchAnimeToggle);
    on<LoadAnime>(_onLoadAnime);
    on<AddAnime>(_onAddAnime);
    on<UpdateAnime>(_onUpdateAnime);
    on<DeleteAnime>(_onDeleteAnime);
    on<DeleteAll>(_onDeleteAll);
  }

  Future<void> _onSearchAnimeToggle(event, emit) async{
    _searchMode = !searchMode;
    //print(searchMode);
    //emit(AnimeLoading());
    emit(AnimeListLoaded(animes: animes, searchMode: _searchMode));
  }

  Future<void> dispose() async {
    // Perform cleanup or close all created streams.
    await close();
  }
  
  Future<void> _onLoadAnimeList(event, emit) async {
    try {
      _animes = await animeRepo.fetchAll();
      emit(
        AnimeListLoaded(animes: animes, searchMode: searchMode)
      );      
    } on Exception catch (e) {
      log(e.toString());
    }
  }
  
  Future<void> _onSearchAnime(event, emit) async {
    //final state = this.state;
    _animes = await animeRepo.fetchAll();
    _animes = animes.where((element) {
      return element.title.toLowerCase().contains(event.str.toLowerCase());
    },).toList();

    emit(AnimeListLoaded(animes: animes, searchMode: searchMode));
  }

  void _onLoadAnime(LoadAnime event, Emitter<AnimeState> emit) async {
    final anime = await animeRepo.fetchById(event.id);
    try {
      emit(AnimeLoaded(anime: anime));
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void _onAddAnime(event, emit) async {
    try {
      await animeRepo.insert(event.title, event.description, event.episodes);
      _animes = await animeRepo.fetchAll();
      final state = this.state;
      if(state is AnimeListLoaded){
        emit(AnimeListLoaded(animes: animes, searchMode: searchMode));
        print(animes);
        print('ANIMELISTLOADED STATE');
      }
      else{
        print('$state STATE');
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    
  }
  void _onUpdateAnime(event, emit) async {
    await animeRepo.update(event.id, event.title, event.description, event.episodes);
    final state = this.state;
    
    _animes = await animeRepo.fetchAll();
    Anime anime = await animeRepo.fetchById(event.id);


    if(state is AnimeLoaded){
      
      emit(AnimeLoaded(anime: anime));
    }
    else if(state is AnimeListLoaded){
      emit(AnimeLoaded(anime: anime));
      emit(AnimeListLoaded(animes: animes, searchMode: searchMode));
    }
  }

  void _onDeleteAnime(event, emit) async {
    try {
      await animeRepo.delete(event.anime.id!);
      final state  = this.state;
      if(state is AnimeListLoaded){
        _animes = await animeRepo.fetchAll();
        emit(AnimeListLoaded(animes: animes, searchMode: searchMode));
      }
    } on Exception catch (e) {
      log(e.toString());
    }

  }

  Future<void> _onDeleteAll(event, emit) async {
  await animeRepo.deleteAll();
    final state  = this.state;
    if(state is AnimeListLoaded){
      print('ANIMELISTLOADED STATE and EVENT $event');
      _animes = [];
      emit(AnimeListLoaded(animes: animes, searchMode: searchMode));
    }
    else{
      print('$state STATE and EVENT $event');
    }
  }
  // on<AddAnime>((event, emit) {
  //   // TODO: implement event handler
  //   if(state is AnimeLoaded){
  //     final state = this.state as AnimeLoaded;
  //     emit(
  //       AnimeLoaded(
  //         animes: List.from(state.animes)..add(event.anime),
  //       )
  //     );
  //   }
  // });
  // on<DeleteAnime>((event, emit) {
  //   // TODO: implement event handler
  //   if(state is AnimeLoaded){
  //     final state = this.state as AnimeLoaded;
  //     emit(
  //       AnimeLoaded(
  //         animes: List.from(state.animes)..remove(event.anime),
  //       )
  //     );
  //   }
  // });
  
}
