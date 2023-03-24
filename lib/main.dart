import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spac/screens/praveen/item_list_screen/item_list_screen.dart';
import 'package:spac/screens/suvin/AddToDo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    home: ItemListScreen(),
  ));
}

