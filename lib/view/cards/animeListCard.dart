
import 'package:animain/model/animeModel.dart';
import 'package:animain/view/animePage.dart';
//import 'package:animain/view/homePage.dart';
import 'package:flutter/material.dart';

class AnimeListCard extends StatelessWidget{
  const AnimeListCard({Key? key, required this.anime, required this.callback}) : super(key: key);
  final AnimeModel anime;
  final VoidCallback callback;


    @override
    Widget build(BuildContext context){
      return Container(
        decoration: BoxDecoration(
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: GestureDetector(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnimePage(anime: anime, title: anime.title,)));
              callback();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              ),
              height: 80,
              padding: EdgeInsets.all(8),
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
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )
                        ),
                        Text('${anime.episodes} Episodes',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )
                        ),
                      ],
                    ),
                    // SizedBox(width: 4,),
                    //   IconButton(icon: Icon(Icons.delete_rounded, color: Colors.red, size: 24,),
                    //   onPressed: () {
                    //     showRemovePrompt(context, callback, anime);
                    //   },
                    // ),
                      ],
                      
                    ),
                ],
              ),
                
                
              ),
          ),
        ),
      );
    }
  }
// void showRemovePrompt(BuildContext context, VoidCallback callback, AnimeModel anime){
//   showDialog(context: context, builder: (context){
//     return AlertDialog(
//       actionsAlignment: MainAxisAlignment.spaceEvenly,
//       actions: [
//         //No Button
//         GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: const Text("Cancel",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
          
//           )
//         ),
//         GestureDetector(
//           onTap: () {
//             //deleteAnime(anime);
//             Navigator.of(context).pop();
//           } ,
//           child: const Text("DELETE",
//             style: TextStyle(
//               color: Colors.redAccent,
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//           )
//         ),
//       ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(
//                 20.0,
//               ),
//             ),
//           ),
//           contentPadding: EdgeInsets.only(
//             top: 10.0,
//           ),
//           title: Center(
//             child: Text(
//               "Delete ${anime.title}?",
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontSize: 20.0),
//             ),
//           ),
//         );
//   });
// }