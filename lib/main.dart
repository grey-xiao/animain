import 'package:flutter/material.dart';
import 'package:animain/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

String appTitle = 'Animain';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animain',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(title: appTitle),
    );
  }
}