import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spac/screens/aatharsan/signin.dart';
import 'package:spac/screens/praveen/item_list_screen/item_list_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: SignIn(), // SignIn() ItemListScreen()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}