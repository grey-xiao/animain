
import 'package:animain/controller/anime_controller.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/view/anime_page.dart';
import 'package:animain/view/dialogs/delete_dialog.dart';
//import 'package:animain/view/homePage.dart';
import 'package:flutter/material.dart';

class AnimeListCard extends StatelessWidget{
  const AnimeListCard({super.key, required this.anime, required this.callback, required this.animeDB, required this.parentContext});
  final Anime anime;
  final VoidCallback callback;
  final BuildContext parentContext;
  final AnimeController animeDB;


    @override
    Widget build(BuildContext context){
      return Container(
        decoration: const BoxDecoration(
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(parentContext, MaterialPageRoute(
                settings: const RouteSettings(name: 'Main'),
                builder: (parentContext) => AnimePage(anime: anime, title: anime.title, callback: callback,)));
              callback();
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
                          )
                        ),
                        Text('${anime.episodes} Episodes',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(width: 4,),
                      IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 24,),
                      onPressed: () {
                        showDeletePrompt(context, callback, anime);
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
  void showDeletePrompt(BuildContext context, VoidCallback callback, Anime anime){
    showDialog(context: context, builder: (context){
      return DeleteDialog(anime: anime, animeDB: animeDB, callback: callback, mode: 'single', onSubmit: (value) {},);
    });
  }
}
