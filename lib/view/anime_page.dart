import 'dart:async';

import 'package:animain/controller/anime_controller.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/view/forms/anime_form.dart';
import 'package:flutter/material.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({super.key, required this.anime, required this.title, required this.callback});
  final String title;
  final Anime anime;
  final VoidCallback callback;

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  int value = 0;
  Anime updatedAnime =  Anime(id: 0, title: '', description: '', episodes: 0);
  Anime displayedAnime = Anime(id: 0, title: '', description: '', episodes: 0);
  final animeDB = AnimeController();
  

  final _globalKey = GlobalKey<ScaffoldMessengerState>();


  @override
  void initState() {
    animeDB.getQueriesFromXML(context);
    setState(() {
      displayedAnime = widget.anime;
    });

    super.initState();
  }

  Future fetchAnime() async {
    updatedAnime = await animeDB.fetchById(displayedAnime.id);
    setState(() {
      displayedAnime = updatedAnime;
    });
  }

  Future<Anime> futureAnime() async{
    return displayedAnime;
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
    return result == 1 
      ? _globalKey.currentState!.showSnackBar(successMsg)
      : _globalKey.currentState!.showSnackBar(failedMsg);
  }


  showUpdateForm(BuildContext context, Anime anime, VoidCallback callback) async{
    int success = 0;
    showDialog(
      context: context, 
      builder: (_) => AnimeForm(
        anime: anime,
        callback: callback,
        onSubmit: (animeUsed) async {
          success = await animeDB.update(
            id: anime.id,
            title: animeUsed[0], 
            description: animeUsed[1], 
            episodes: int.parse(animeUsed[2]),
          );
          
          if(!mounted) return;
          showMessage(success);
          Navigator.of(context).pop();
       },
      ),
    );
    
    
     
  }

  showDeletePrompt(BuildContext context, Anime anime, VoidCallback callback) async {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
              callback();
              // Navigator.of(context).pop();
              // Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    void refresh(){
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
        fetchAnime();
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Information'),
          actions: [
            PopupMenuButton<int>(
              // Callback that sets the selected popup menu item.
              onSelected: (int item) async {
                switch(item){
                  case 1:
                    showUpdateForm(context, displayedAnime, refresh);
                    break;
                  case 2:
                    await showDeletePrompt(context, displayedAnime, widget.callback);
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
              ]
            ),
            // IconButton(icon: Icon(Icons.more_vert_rounded, size: 24,),
            //   onPressed: () {
                
            //   },
            // ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder(
              future: futureAnime(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                }
                else{
                  if(snapshot.hasData){
                    return Column(
                      children: <Widget>[
                        Center(
                          child: Text(displayedAnime.title,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text("${displayedAnime.episodes} episodes",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        Text(displayedAnime.description,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
          ),
        ),
      ),
    );
  }
}