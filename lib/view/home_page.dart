import 'package:animain/controller/anime_controller.dart';
import 'package:animain/view/cards/anime_list_card.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/view/forms/anime_form.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

  
class _HomePageState extends State<HomePage> {
  final animeDB = AnimeController();

  List<Anime> aniList = [];
  List<Anime> viewableList = [];
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  ScrollController _controller = ScrollController();
  bool searchAction = false;
  bool noData = true;
  MaterialColor deleteButtonColor = Colors.red;
  
  
  Future<List<Anime>> futureAnimeList() async{
    return viewableList;
  }
  
  final TextEditingController _searchController = TextEditingController();


  Future fetchAnimeList() async{
    aniList = await animeDB.fetchAll();
    setState(() {
      viewableList = aniList;
      noDataCheck(viewableList);
    });
  }

  void noDataCheck(List<Anime> list) {
    if(list.isEmpty){
      setState(() {
        noData = true;
        deleteButtonColor = Colors.grey;
      });
    }
    else{
      setState(() {
        noData = false;
        deleteButtonColor = Colors.red;
      });
    }
  }

  @override
  void initState() {
    animeDB.getQueriesFromXML(context);

    fetchAnimeList();
    super.initState();
  }

  
  showMessage(int result){
    const successMsg = SnackBar(
      content: Text('Success.'),
      showCloseIcon: true,
    );
    const failedMsg = SnackBar(
        content: Text('That title already exists!'),
        showCloseIcon: true,
      );
    return result != 0 
      ? _globalKey.currentState?.showSnackBar(successMsg)
      : _globalKey.currentState?.showSnackBar(failedMsg);
  }
  
  
  Future onSearchTextChanged(String text) async {
    setState(() {
      viewableList = [];
      if (text.isNotEmpty) {
        for(int i = 0; i < aniList.length; i++){
          if(aniList[i].title.toLowerCase().contains(text.toLowerCase())){
            viewableList.add(aniList[i]);
          }
        }
      }
      else{
        viewableList = aniList;
      }
    });
  }

  void showDeleteAllPrompt(BuildContext context, VoidCallback callback){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          //No Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            
            )
          ),
          TextButton(
            onPressed: () async {
              await animeDB.deleteAll();
              callback();
              if(!mounted) return;
              Navigator.of(context).pop();
            } ,
            child: const Text("DELETE",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ),
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
    });
  }
  
  Future<bool> showDeletePrompt(BuildContext context, Anime anime, VoidCallback callback) async{
    bool decision = false;
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () {
              decision = false;
              Navigator.of(context).pop();
            },
            child: const Text("Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            
            )
          ),
          GestureDetector(
            onTap: () async {
              await animeDB.delete(anime.id);
              decision = true;
              callback();
              Navigator.of(context).pop();
            } ,
            child: const Text("DELETE",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ),
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
                "Delete ${anime.title}?",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          );
        }
      );
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
          showMessage(success);
          Navigator.of(context).pop();
          fetchAnimeList();
          if(!mounted) return;
          

        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    void refresh(){
      
      // Timer(const Duration(milliseconds: 200), (){
      //   setState(() {
      //     fetchAnime();
      //   });
      // });
      showDialog(
          barrierDismissible: false,
          context: context, 
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        );
      Timer(const Duration(milliseconds: 200), (){
        
        //Fetch Data before Render Refresh
        fetchAnimeList();
        //Render Refresh
        setState((){
          //print("Page Updated");
        });
      });
      Navigator.of(context).pop();
    }
    return ScaffoldMessenger(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          leading: searchAction ? 
          IconButton(icon: const Icon(Icons.arrow_back, size: 24,),
            onPressed: () {
              setState(() {
                searchAction = false;
              });
            },
          )
          : const SizedBox(),
          leadingWidth: searchAction ?
          56
          : 0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              searchAction ? Container(
                width: MediaQuery.of(context).size.width*3/4,
                height: 40,
                
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        searchAction = false;
                      });
                    },
                    autofocus: true,
                    controller: _searchController,
                    onChanged: (value) => onSearchTextChanged(_searchController.text),
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
          actions: searchAction ? 
          []
          : [
            IconButton(icon: const Icon(Icons.search_rounded, size: 24,),
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
              onPressed: noData ?
              null
              : () {
                showDeleteAllPrompt(context, refresh);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: futureAnimeList(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      if(snapshot.hasData){
                        final animeList = snapshot.data!;
                        
                        return animeList.isEmpty 
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
                            height: MediaQuery.of(context).size.height*4/5,
                            child: ListView.builder(
                              controller: _controller,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              
                              itemCount: animeList.length,
                              itemBuilder: (context, index) {
                                final Anime anime = animeList[index];
                                return Dismissible(
                                  key: Key(anime.title),
                                  //TODO
                                  confirmDismiss: (direction) => showDeletePrompt(context, anime, refresh),
                                  onDismissed: (direction) {
                                    
                                  },
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
                                    child: AnimeListCard(parentContext: context, anime: anime, callback: refresh, animeDB: animeDB,),
                                  ),
                                );
                              },
                            ),
                          );
                      }
                      else {
                        return const Center(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                    }  
                  }
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddForm(context, refresh),
          tooltip: 'Add New',
          child: const Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
    
  }
}
