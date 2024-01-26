import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/util/strings.dart';
import 'package:animain/view/cards/anime_list_card.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/view/forms/add_anime_form.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AnimeBloc _animeBloc;

  bool searchAction = false;
  bool noData = true;
  MaterialColor deleteButtonColor = Colors.red;
  final TextEditingController _searchController = TextEditingController();
  // static bool _searchMode = false;
  // static bool get searchMode => _searchMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _animeBloc = AnimeBloc()..add(LoadAnimeList());
    super.didChangeDependencies();
  }

  // void noDataCheck(List<Anime> list) {
  //   if (list.isEmpty) {
  //     setState(() {
  //       noData = true;
  //       deleteButtonColor = Colors.grey;
  //     });
  //   } else {
  //     setState(() {
  //       noData = false;
  //       deleteButtonColor = Colors.red;
  //     });
  //   }
  // }

  // Future onSearchTextChanged(String text) async {
  //   setState(() {
  //     viewableList = [];
  //     if (text.isNotEmpty) {
  //       for (int i = 0; i < aniList.length; i++) {
  //         if (aniList[i].title.toLowerCase().contains(text.toLowerCase())) {
  //           viewableList.add(aniList[i]);
  //         }
  //       }
  //     } else {
  //       viewableList = aniList;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _animeBloc,
      child: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if (state is AnimeListLoaded) {
            print(state.searchMode);
            bool searchMode = _animeBloc.searchMode;
            return Scaffold(
              appBar: AppBar(
                leading: searchMode ? leadingContents() : const SizedBox(),
                leadingWidth: searchMode ? 56 : 0,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: titleContents(),
                actions: searchMode
                    ? []
                    : [
                        IconButton(
                          icon: const Icon(
                            Icons.search_rounded,
                            size: 24,
                          ),
                          onPressed: () {
                            //_searchMode = !_searchMode;
                            _animeBloc.add(const SearchAnimeToggle());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_sweep_rounded,
                            color: _animeBloc.animes.isNotEmpty
                                ? deleteButtonColor
                                : Colors.grey,
                            size: 24,
                          ),
                          onPressed: _animeBloc.animes.isNotEmpty
                              ? () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return deleteDialog(context);
                                      });
                                }
                              : null,
                        ),
                      ],
              ),
              body: body(context),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: _animeBloc,
                      child: const AddAnimeForm(),
                    ),
                  );
                },
                tooltip: 'Add New',
                child: const Icon(Icons.add),
              ),
              resizeToAvoidBottomInset: true,
            );
          } else if (state is AnimeLoading) {
            return Scaffold(
                body: Center(child: const CircularProgressIndicator()));
          } else if (state is AnimeSearching) {
            return AppBar(
              leading: leadingContents(),
              leadingWidth: 56,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: titleContents(),
            );
          } else {
            print(state);
            return Center(
              child: Text(defaultErrorString),
            );
          }
        },
      ),
    );
  }

  Widget body(BuildContext context) {
    return BlocProvider.value(
        value: _animeBloc,
        child: BlocConsumer<AnimeBloc, AnimeState>(
          listener: (context, state) {
            if (state is AnimeListLoaded) {}
          },
          builder: (context, state) {
            return BlocBuilder<AnimeBloc, AnimeState>(
              builder: (context, state) {
                if (state is AnimeLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AnimeListLoaded) {
                  List<Anime> animeList = _animeBloc.animes;

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          animeList.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No Data',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      4 /
                                      5,
                                  // child: RefreshIndicator(
                                  // onRefresh: () {
                                  //   final animeBloc = BlocProvider.of<AnimeBloc>(context)..add(AnimeRefresh());
                                  //   return animeBloc.firstWhere((e) => e is! AnimeRefresh);
                                  // },
                                  child: ListView.builder(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: animeList.length,
                                    itemBuilder: (context, index) {
                                      final Anime anime = animeList[index];
                                      //final Anime anime = animeList[index];
                                      return Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        decoration: const BoxDecoration(
                                            border: BorderDirectional(
                                                bottom: BorderSide())),
                                        child: AnimeListCard(
                                          anime: anime,
                                          animeBloc: _animeBloc,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text(defaultErrorString);
                }
              },
            );
          },
        ));
  }

  Widget titleContents() {
    return BlocProvider.value(
      value: _animeBloc,
      child: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if (state is AnimeListLoaded) {
            return _animeBloc.searchMode
                ? Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: TextField(
                            autofocus: true,
                            controller: _searchController,
                            onChanged: (value) =>
                                _animeBloc.add(SearchAnime(str: value)),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                  },
                                ),
                                hintText: 'Search...',
                                border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  )
                : Text(appTitleString);
          } else if (state is AnimeSearchLoaded) {
            return Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextField(
                      autofocus: true,
                      controller: _searchController,
                      onChanged: (value) =>
                          _animeBloc.add(SearchAnime(str: value)),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                              _searchController.clear();
                            },
                          ),
                          hintText: 'Search...',
                          border: InputBorder.none),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Text('NEITHER'),
            );
          }
        },
      ),
    );
  }

  Widget leadingContents() {
    return BlocProvider.value(
      value: _animeBloc,
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 24,
        ),
        onPressed: () {
          _searchController.text = '';
          _animeBloc.add(const SearchAnimeToggle());
        },
      ),
    );
  }

  Widget deleteDialog(BuildContext context) {
    return AlertDialog(
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
              _animeBloc.add(const DeleteAll());
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
      title: const Center(
        child: Text(
          "Delete all records?",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
