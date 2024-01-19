import 'dart:async';

import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/controller/anime_controller.dart';
import 'package:animain/controller/xml_query_controller.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';
import 'package:animain/view/dialogs/delete_dialog.dart';
import 'package:animain/view/forms/anime_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimePage extends StatefulWidget {
  const AnimePage(
      {super.key,
      required this.anime,
      required this.title,
      required this.callback});
  final String title;
  final Anime anime;
  final VoidCallback callback;

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  int value = 0;
  Anime updatedAnime = Anime(id: 0, title: '', description: '', episodes: 0);
  Anime displayedAnime = Anime(id: 0, title: '', description: '', episodes: 0);
  final animeDB = AnimeController();
  final xmlQuery = XMLQuery();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    
    setState(() {
      displayedAnime = widget.anime;
    });

    super.initState();
  }

  Future fetchAnime() async {
    animeDB.queries = await xmlQuery.getQueriesFromXML(context);
    updatedAnime = await animeDB.fetchById(displayedAnime.id!);
    setState(() {
      displayedAnime = updatedAnime;
    });
  }

  Future<Anime> futureAnime() async {
    return displayedAnime;
  }

  showMessage(int result) {
    SnackBar msg = SnackBar(
      content: Text(result != 0 ? successMsgString : dupeMsgString),
      showCloseIcon: true,
    );
    return _globalKey.currentState?.showSnackBar(msg);
  }

  showUpdateForm(
      BuildContext context, Anime anime, VoidCallback callback) async {
    int success = 0;
    showDialog(
      context: context,
      builder: (_) => AnimeForm(
        anime: anime,
        callback: callback,
        onSubmit: (animeUsed) async {
          success = await animeDB.update(
            id: anime.id!,
            title: animeUsed[0],
            description: animeUsed[1],
            episodes: int.parse(animeUsed[2]),
          );

          if (!mounted) return;
          showMessage(success);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  showDeletePrompt(
      BuildContext context, Anime anime, VoidCallback callback) async {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteDialog(
            anime: anime,
            animeDB: animeDB,
            callback: callback,
            mode: 'single',
            onSubmit: (value) {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    void refresh() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      Timer(const Duration(milliseconds: 200), () {
        //Fetch Data before Render Refresh
        fetchAnime();
        //Render Refresh
        setState(() {
          //print("Page Updated");
        });
      });
      Navigator.of(context).pop();
    }

    return BlocProvider(
      create: (context) => AnimeBloc()..add(LoadAnime(id: widget.anime.id!)),
      child: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Information'),
            actions: [
              PopupMenuButton<int>(
                  // Callback that sets the selected popup menu item.
                  onSelected: (int item) async {
                    switch (item) {
                      case 1:
                        showUpdateForm(context, displayedAnime, refresh);
                        break;
                      case 2:
                        await showDeletePrompt(
                            context, displayedAnime, widget.callback);
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
          body: BlocBuilder<AnimeBloc, AnimeState>(
            builder: (context, state) {
              if (state is AnimeLoading) {
                return const CircularProgressIndicator();
              }
              if (state is AnimeLoaded) {
                final anime = state.anime;
                print('ANIME ID ${anime.id}');
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
                return const Text(defaultErrorString);
              }
            },
          ),
        ),
      ),
    );
  }
}
