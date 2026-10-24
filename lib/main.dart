import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme.dart';

/// This is the very first line of code that runs when the app starts.
/// It tells Flutter: "please put PetPalApp on the screen".
void main() {
  runApp(const PetPalApp());
}

/// The whole app lives inside this widget.
///
/// `main.dart` is tiny. It does not decide which screen to show — it names the
/// *first* one and hands over the theme. The Navigator does the rest.
class PetPalApp extends StatelessWidget {
  const PetPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPal',
      debugShowCheckedModeBanner: false,
      theme: buildPetPalTheme(),
      home: const WelcomeScreen(),
    );
  }
}
