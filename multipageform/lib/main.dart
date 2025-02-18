import 'package:flutter/material.dart';
import 'screens/screen1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Form App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const Screen1(),
    );
  }
}