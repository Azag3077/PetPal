import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/name_screen.dart';

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
      home: const PetPalRoot(),
    );
  }
}

/// Decides which screen to show.
///
/// Before the player has named a pet we show the NameScreen. Once they have,
/// we keep their answers here and show the HomeScreen instead.
///
/// This is the simplest possible way to swap screens: one `if`. In the next
/// lesson we will do it properly with Flutter's Navigator.
class PetPalRoot extends StatefulWidget {
  const PetPalRoot({super.key});

  @override
  State<PetPalRoot> createState() => _PetPalRootState();
}

class _PetPalRootState extends State<PetPalRoot> {
  /// Null until the player has named their pet.
  String? _petName;
  Color? _petColor;

  @override
  Widget build(BuildContext context) {
    if (_petName == null || _petColor == null) {
      return NameScreen(
        onReady: (name, color) {
          setState(() {
            _petName = name;
            _petColor = color;
          });
        },
      );
    }

    return HomeScreen(petName: _petName!, petColor: _petColor!);
  }
}
