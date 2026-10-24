import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/main.dart';

void main() {
  testWidgets('the blank app shows the word PetPal', (tester) async {
    // Build the app.
    await tester.pumpWidget(const PetPalApp());

    // Check the word is on the screen.
    expect(find.text('PetPal'), findsOneWidget);

    // There is nothing else yet, so there should be no buttons.
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
