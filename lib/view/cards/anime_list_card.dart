import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';
import 'package:animain/view/anime_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimeListCard extends StatelessWidget {
  const AnimeListCard(
      {super.key, required this.anime, required this.animeBloc});
  final Anime anime;
  final AnimeBloc animeBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'Main'),
                builder: (context) => AnimePage(
                  anime: anime,
                  title: anime.title,
                  animeBloc: animeBloc,
                )
              )
            ).then((value) => animeBloc.add(const LoadAnimeList()));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            height: 80,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(anime.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            )),
                        Text('${anime.episodes} Episodes',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                        size: 24,
                      ),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value: animeBloc,
                                  child: deleteDialog(context),
                                ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteDialog(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(deleteMsgString),
          showCloseIcon: true,
        ));
      },
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )),
          TextButton(
              onPressed: () {
                animeBloc.add(DeleteAnime(anime: anime));
                Navigator.of(context).pop();
              },
              child: const Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.only(
          top: 10.0,
        ),
        title: Center(
          child: Text(
            'Delete ${anime.title}?',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
