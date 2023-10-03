
import 'package:flutter/material.dart';
import 'package:my_app/loginforms/getstared.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GetStarted(),
    );
  }
}
