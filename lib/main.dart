import 'package:download_file/home.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOT ComplyPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x33d1b8)),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: const Home(),
    );
  }
}



