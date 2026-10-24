import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/main.dart';

void main() {
  testWidgets('feeding the pet makes the hunger number go down',
      (tester) async {
    await tester.pumpWidget(const PetPalApp());

    // Hunger starts at 40.
    expect(find.text('40'), findsOneWidget);

    // Tap the Feed button (the first filled icon button).
    await tester.tap(find.byIcon(Icons.restaurant));
    await tester.pump();

    // Feeding takes 25 off hunger, so now it should be 15.
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('stats never go below 0', (tester) async {
    await tester.pumpWidget(const PetPalApp());

    // Feed five times. 40 - (5 * 25) would be -85 without clamping.
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.restaurant));
      await tester.pump();
    }

    expect(find.text('0'), findsOneWidget);
  });
}
