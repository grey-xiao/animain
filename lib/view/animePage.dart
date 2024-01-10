import 'dart:js_interop_unsafe';

import 'package:animain/model/animeModel.dart';
import 'package:animain/view/homePage.dart';
import 'package:flutter/material.dart';

class AnimePage extends StatelessWidget {
  const AnimePage({super.key, required this.anime, required this.title});
  final String title;
  final AnimeModel anime;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(icon: Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24,),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(anime.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text("${anime.episodes} episodes",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16,),
              Text(anime.description,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}