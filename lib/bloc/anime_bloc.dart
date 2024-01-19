import 'package:animain/controller/xml_query_controller.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/controller/anime_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  AnimeBloc() : super(AnimeLoading()) {
    on<LoadAnimeList>(_onLoadAnimeList);
    on<LoadAnime>(_onLoadAnime);
    on<AddAnime>(_onAddAnime);
    on<UpdateAnime>(_onUpdateAnime);
    on<DeleteAnime>(_onDeleteAnime);
  }
  // AnimeController ac = AnimeController();
  // final xmlQuery = XMLQuery();
  // Future<void> getQueries() async {
  //   ac.queries = await xmlQuery.getQueriesFromXML(context);
  // }
  
    Future<void> _onLoadAnimeList(LoadAnimeList event, Emitter<AnimeState> emit) async {
      List<Anime> animes = await AnimeController().fetchAll();
      emit(AnimeLoading());
      emit(
        AnimeListLoaded(animes: animes)
      );
    }
    void _onLoadAnime(LoadAnime event, Emitter<AnimeState> emit) async {
      Anime anime = await AnimeController().fetchById(event.id);

      emit(
        AnimeLoaded(anime: anime)
      );
    }
    void _onAddAnime(AddAnime event, Emitter<AnimeState> emit) async {
      await AnimeController().insert(title: event.title, description: event.description, episodes: event.episodes);

      final animes = await AnimeController().fetchAll();
      
      Anime anime = animes.firstWhere((element) => element.title == event.title);

      // List<Anime> list = [];
      // list.add(anime);

      final state = this.state;
      emit(AnimeLoading());
      if(state is AnimeListLoaded){
        emit(AnimeListLoaded(animes: List.from(state.animes)..add(anime)));
      }
      
    }
    void _onUpdateAnime(UpdateAnime event, Emitter<AnimeState> emit) async {
      await AnimeController().update(id: event.id, title: event.title, description: event.description, episodes: event.episodes);
      final state = this.state;
      Anime anime = await AnimeController().fetchById(event.id);
      //Anime anime = Anime(id: event.id, title: event.title, description: event.description, episodes: event.episodes);


      if(state is AnimeLoaded){
        // List<Anime> animes = (state.animes.map((ani) {
        //   return ani.id == event.id ? anime : ani;
        // })).toList();

        emit(AnimeLoaded(anime: anime));
      }
    }
    void _onDeleteAnime(DeleteAnime event, Emitter<AnimeState> emit) {


      final state  = this.state;

      if(state is AnimeListLoaded){
        List<Anime> animes = state.animes.where(
          (anime) {
            return anime.id != event.anime.id;
          }
        ).toList();
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
