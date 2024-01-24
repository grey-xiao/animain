import 'dart:async';
import 'dart:developer';

import 'package:animain/model/anime_model.dart';
import 'package:animain/controller/anime_controller.dart';
// import 'package:animain/repository/anime_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  //final _animeRepo = AnimeRepository();
  //final _animeController = StreamController<List<Anime>>.broadcast();
  static List<Anime> animes = [];

  AnimeBloc() : super(AnimeLoading()) {
    on<LoadAnimeList>(_onLoadAnimeList);
    on<SearchAnime>(_onSearchAnime);
    on<LoadAnime>(_onLoadAnime);
    on<AddAnime>(_onAddAnime);
    on<UpdateAnime>(_onUpdateAnime);
    on<DeleteAnime>(_onDeleteAnime);
    on<DeleteAll>(_onDeleteAll);
  }
  
    Future<void> _onLoadAnimeList(LoadAnimeList event, Emitter<AnimeState> emit) async {
      //_animeController.sink.add(await _animeRepo.fetchAll());

      animes = await AnimeController().fetchAll();
      emit(AnimeLoading());
      emit(
        AnimeListLoaded(animes: animes)
      );
    }
    void _onSearchAnime(SearchAnime event, Emitter<AnimeState> emit) async {
      final state = this.state;

      if(state is AnimeListLoaded  &&  state is AnimeSearchLoaded){
        animes = state.animes.where((element) {
          return element.title.toLowerCase().contains(event.str.toLowerCase());
        },).toList();

        emit(AnimeSearchLoaded(animes: animes));
      }

      
    }
    void _onLoadAnime(LoadAnime event, Emitter<AnimeState> emit) async {
      Anime anime = Anime(title: '', description: '', episodes: 0);
      if(event.id != null){
       anime = await AnimeController().fetchById(event.id!);
      } 

      emit(AnimeLoaded(anime: anime));
    }

    void _onAddAnime(AddAnime event, Emitter<AnimeState> emit) async {
      await AnimeController().insert(title: event.title, description: event.description, episodes: event.episodes);
      //Anime anime = rawList.firstWhere((element) => element.title == event.title);
      animes = await AnimeController().fetchAll();
      Anime anime = animes.firstWhere((element) => element.title == event.title);
      print(anime);
      final state = this.state;
      emit(AnimeLoading());
      emit(AnimeLoaded(anime: anime));
      //emit(AnimeListLoaded(animes: animes));
      if(state is AnimeListLoaded){
        // animes = rawList.where(
        //   (anime) {
        //     return anime.title == event.title;
        //   }
        // ).toList();

        //emit(AnimeListLoaded(animes: List.from(state.animes)..add(anime)));
        print('ANIMELISTLOADED STATE');
      }
      else{
        print('$state STATE');
      }
      
    }
    void _onUpdateAnime(UpdateAnime event, Emitter<AnimeState> emit) async {
      await AnimeController().update(id: event.id, title: event.title, description: event.description, episodes: event.episodes);
      final state = this.state;
      Anime anime = await AnimeController().fetchById(event.id);
      //Anime anime = Anime(id: event.id, title: event.title, description: event.description, episodes: event.episodes);

      emit(AnimeLoading());

      if(state is AnimeLoaded){
        // animes = (state.animes.map((ani) {
        //   return ani.id == event.id ? anime : ani;
        // })).toList();
        
        emit(AnimeLoaded(anime: anime));
      }
    }
    void _onDeleteAnime(DeleteAnime event, Emitter<AnimeState> emit) async {
    await AnimeController().delete(event.anime.id!);

      final state  = this.state;

      if(state is AnimeListLoaded){
        animes = state.animes.where(
          (anime) {
            return anime.id != event.anime.id;
          }
        ).toList();
        emit(AnimeListLoaded(animes: animes));
      }

    }
    void _onDeleteAll(DeleteAll event, Emitter<AnimeState> emit) async {
    await AnimeController().deleteAll();

      final state  = this.state;

      if(state is AnimeListLoaded){
        animes = [];
        emit(AnimeListLoaded(animes: animes));
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
