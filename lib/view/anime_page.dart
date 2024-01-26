import 'dart:async';

import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';
import 'package:animain/view/forms/edit_anime_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({
    super.key,
    required this.anime,
    required this.title,
    required this.animeBloc,
  });
  final String title;
  final Anime anime;
  final AnimeBloc animeBloc;

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  int value = 0;

  @override
  void initState() {
    super.initState();
  }

  // Future<Anime> futureAnime() async {
  //   return displayedAnime;
  // }

  // showMessage(int result) {
  //   SnackBar msg = SnackBar(
  //     content: Text(result != 0 ? successMsgString : dupeMsgString),
  //     showCloseIcon: true,
  //   );
  // }

  // showUpdateForm(
  //     BuildContext context, Anime anime, VoidCallback callback) async {
  //   showDialog(
  //     context: context,
  //     builder: (_) => EditAnimeForm(
  //       anime: anime,
  //       callback: callback,
  //     ),
  //   );
  // }

  // showDeletePrompt(BuildContext context, Anime anime) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return DeleteDialog(
  //           anime: anime,
  //           mode: 'single',
  //           onSubmit: (value) {},
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    // void refresh() {
    //   showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (context) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       });
    //   Timer(const Duration(milliseconds: 200), () {
    //     //Fetch Data before Render Refresh
    //     //Render Refresh
    //     setState(() {});
    //   });
    //   Navigator.of(context).pop();
    // }

    return BlocProvider.value(
        value: widget.animeBloc..add(LoadAnime(id: widget.anime.id!)),
        child: BlocBuilder<AnimeBloc, AnimeState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Information'),
                actions: [
                  PopupMenuButton<int>(
                      // Callback that sets the selected popup menu item.
                      onSelected: (int item) async {
                        switch (item) {
                          case 1:
                            await showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: widget.animeBloc,
                                child: EditAnimeForm(anime: widget.anime,),
                              ),
                            );
                            break;
                          case 2:
                            await showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: widget.animeBloc,
                                child: deleteDialog(context),
                              ),
                            );
                        }
                      },
                      itemBuilder: (buildContext) => <PopupMenuEntry<int>>[
                            const PopupMenuItem(
                              value: 1,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ]),
                ],
              ),
              body: body(context),
            );
          },
        ));
  }

  Widget body(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) {
        if (state is AnimeLoading) {
          return const CircularProgressIndicator();
        }
        if (state is AnimeLoaded) {
          final anime = state.anime;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        anime.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "${anime.episodes} episodes",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      anime.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SafeArea(child: Center(child: const Text(defaultErrorString)));
        }
      },
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
                widget.animeBloc.add(DeleteAnime(anime: widget.anime));
                Navigator.of(context).popUntil((route) => route.isFirst);
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
            'Delete ${widget.anime.title}?',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
