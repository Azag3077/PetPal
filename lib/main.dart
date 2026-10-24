import 'package:flutter/material.dart';

/// This is the very first line of code that runs when the app starts.
/// It tells Flutter: "please put PetPalApp on the screen".
void main() {
  runApp(const PetPalApp());
}

/// The whole app lives inside this widget.
/// A MaterialApp gives us things like colours, fonts and a screen to draw on.
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
      home: const Scaffold(
        body: Center(
          child: Text('PetPal'),
        ),
      ),
    );
  }
}
