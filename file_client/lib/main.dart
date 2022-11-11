import 'package:file_client/screens/file_screen.dart';
import 'package:file_client/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amrita FileZ',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

