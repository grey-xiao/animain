import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:animain/view/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitleString,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AnimeBloc(),
          ),
        ],
        child: HomePage(title: appTitleString),
      ),
    );
  }
}
