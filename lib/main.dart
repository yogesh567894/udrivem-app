import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const UdriveApp());
}

class UdriveApp extends StatelessWidget {
  const UdriveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Udrive',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
