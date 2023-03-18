import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spac/screens/suvin/AddToDo.dart';
import 'package:spac/screens/suvin/ChoiceType.dart';
import 'package:spac/screens/suvin/ImagePicker.dart';
import 'package:spac/screens/suvin/ViewItems.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    home: IntroductionAnimationScreen()
  ));
}

