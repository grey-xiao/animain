import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/controller/anime_controller.dart';
import 'package:animain/controller/xml_query_controller.dart';
import 'package:animain/util/strings.dart';
import 'package:animain/view/cards/anime_list_card.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/view/dialogs/delete_dialog.dart';
import 'package:animain/view/forms/anime_form.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final animeDB = AnimeController();
  final xmlQuery = XMLQuery();

  List<Anime> aniList = [];
  List<Anime> viewableList = [];
  final _controller = ScrollController();
  bool searchAction = false;
  bool noData = true;
  MaterialColor deleteButtonColor = Colors.red;
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchAnimeList();
    context.read<AnimeBloc>().add(LoadAnimeList());
    
    
  }

  Future fetchAnimeList() async {
    animeDB.queries = await xmlQuery.getQueriesFromXML(context);
    // aniList = await animeDB.fetchAll();
    // setState(() {
    //   viewableList = aniList;
    //   noDataCheck(viewableList);
    // });
  }

  void noDataCheck(List<Anime> list) {
    if (list.isEmpty) {
      setState(() {
        noData = true;
        deleteButtonColor = Colors.grey;
      });
    } else {
      setState(() {
        noData = false;
        deleteButtonColor = Colors.red;
      });
    }
  }

  

  Future onSearchTextChanged(String text) async {
    setState(() {
      viewableList = [];
      if (text.isNotEmpty) {
        for (int i = 0; i < aniList.length; i++) {
          if (aniList[i].title.toLowerCase().contains(text.toLowerCase())) {
            viewableList.add(aniList[i]);
          }
        }
      } else {
        viewableList = aniList;
      }
    });
  }

  Future<bool> showDeletePrompt(
      BuildContext context, Anime? anime, VoidCallback callback, String mode) async {
    bool decision = false;
    await showDialog(
        context: context,
        builder: (context) {
          return DeleteDialog(
              anime: anime,
              animeDB: animeDB,
              callback: callback,
              mode: mode,
              onSubmit: (value) {
                if(mode == 'single'){
                  value ? decision = true : decision = false;
                }
              });
        });
    return decision;
  }

  void showAddForm(BuildContext context, VoidCallback callback) {
    int success = 0;
    showDialog(
      context: context,
      builder: (_) => AnimeForm(
        callback: callback,
        onSubmit: (animeUsed) async {
          success = await animeDB.insert(
            title: animeUsed[0],
            description: animeUsed[1],
            episodes: int.parse(animeUsed[2]),
          );
          //context.read<AnimeBloc>().add();
          //showMessage(success);
          //Navigator.of(context).pop();
          //fetchAnimeList();
          if (!mounted) return;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void refresh() {
      AnimeBloc().add(LoadAnimeList());
    }

    return Scaffold(
      appBar: AppBar(
        leading: searchAction
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    searchAction = false;
                    _searchController.clear();
                  });
                },
              )
            : const SizedBox(),
        leadingWidth: searchAction ? 56 : 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            searchAction
                ? Container(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    height: 40,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextField(
                        autofocus: true,
                        controller: _searchController,
                        onChanged: (value) =>
                            onSearchTextChanged(_searchController.text),
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
                : Text(widget.title),
          ],
        ),
        actions: searchAction
            ? []
            : [
                IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      searchAction = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_sweep_rounded,
                    color: deleteButtonColor,
                    size: 24,
                  ),
                  onPressed: noData
                      ? null
                      : () {
                          showDeletePrompt(context, null, refresh, 'all');
                        },
                ),
              ],
      ),
      body: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if(state is AnimeLoading) {
            return const CircularProgressIndicator();
          }
          if(state is AnimeListLoaded){
            List<Anime> animeList = state.animes;
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
                        height:
                            MediaQuery.of(context).size.height *
                                4 /
                                5,
                        //child: RefreshIndicator(
                          //onRefresh: AnimeBloc().add(LoadAnimeList()),
                          child: ListView.builder(
                            controller: _controller,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: state.animes.length,
                            itemBuilder: (context, index) {
                              final Anime anime = state.animes[index];
                              //final Anime anime = animeList[index];
                              return Dismissible(
                                key: Key(anime.title),
                                confirmDismiss: (direction) => showDeletePrompt(
                                  context, anime, refresh, 'single'),
                                  onDismissed: (direction) {},
                                  background: Container(
                                  color: Colors.redAccent,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  decoration: const BoxDecoration(
                                    border: BorderDirectional(
                                      bottom: BorderSide()
                                    )
                                  ),
                                  child: AnimeListCard(
                                    parentContext: context,
                                    anime: anime,
                                    callback: refresh,
                                    animeDB: animeDB,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      //)
                  ],
                ),
              ),
            );
          }
          else{
            return const Text(defaultErrorString);
          }
          
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddForm(context, refresh),
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
