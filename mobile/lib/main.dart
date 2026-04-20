import 'package:flutter/material.dart';
import 'screens/courts_screen.dart';

void main() {
  runApp(const TennisBnBApp());
}

class TennisBnBApp extends StatelessWidget {
  const TennisBnBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TennisBnB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CourtsScreen(),
    );
  }
}
