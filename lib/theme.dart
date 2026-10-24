import 'package:flutter/material.dart';

/// All of PetPal's colours, fonts and button shapes in one place.
///
/// Before this, every screen chose its own text sizes and paddings. Putting
/// them here means we can change the whole app's look by editing one file —
/// and nobody has to remember what size "big" was.
ThemeData buildPetPalTheme() {
  // We give Flutter one colour to start from and it works out a whole set of
  // matching colours for us: buttons, bars, backgrounds, everything.
  final base = ThemeData(
    colorSchemeSeed: const Color(0xFF00897B), // teal
    useMaterial3: true,
  );

  return base.copyWith(
    // Ordinary text a touch bigger than normal, because our readers are young.
    textTheme: base.textTheme.copyWith(
      bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 18),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 17),
    ),

    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: true,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),

    // Every big button in the app is this shape and this size.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      color: base.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
    ),
  );
}
