import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

/// This is the very first line of code that runs when the app starts.
/// It tells Flutter: "please put PetPalApp on the screen".
void main() {
  runApp(const PetPalApp());
}

/// The whole app lives inside this widget.
///
/// `main.dart` is tiny again. It does not decide which screen to show any
/// more — it just names the *first* one, and the Navigator handles the rest.
class PetPalApp extends StatelessWidget {
  const PetPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPal',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
