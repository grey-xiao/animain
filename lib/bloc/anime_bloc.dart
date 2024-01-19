import 'package:animain/model/anime_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  AnimeBloc() : super(AnimeLoading()) {
    on<LoadAnime>(_onLoadAnime);
    on<AddAnime>(_onAddAnime);
    on<UpdateAnime>(_onUpdateAnime);
    on<DeleteAnime>(_onDeleteAnime);
  }
    void _onLoadAnime(LoadAnime event, Emitter<AnimeState> emit) {
      emit(
        AnimeLoaded(animes: event.animes)
      );
    }
    void _onAddAnime(AddAnime event, Emitter<AnimeState> emit) {
      final state = this.state;

      if(state is AnimeLoaded){
        emit(AnimeLoaded(animes: List.from(state.animes)..add(event.anime)));
      }
    }
    void _onUpdateAnime(UpdateAnime event, Emitter<AnimeState> emit) {
      final state = this.state;

      if(state is AnimeLoaded){
        List<Anime> animes = (state.animes.map((anime) {
          return anime.id == event.anime.id ? event.anime : anime;
        })).toList();

        emit(AnimeLoaded(animes: animes));
      }
    }
    void _onDeleteAnime(DeleteAnime event, Emitter<AnimeState> emit) {
      final state  = this.state;

      if(state is AnimeLoaded){
        List<Anime> animes = state.animes.where(
          (anime) {
            return anime.id != event.anime.id;
          }
        ).toList();
        emit(AnimeLoaded(animes: animes));
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
