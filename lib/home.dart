import 'package:flutter/material.dart';
import 'package:spac/screens/aatharsan/userprofile.dart';

class Main extends StatelessWidget {
  const Main({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfile(),
    );
  }
}
