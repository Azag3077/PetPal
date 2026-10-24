import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/screens/name_screen.dart';

import 'helpers.dart';

void main() {
  testWidgets('Get started opens the name screen', (tester) async {
    await openNameScreen(tester);

    expect(find.text('What will you call your pet?'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('an empty name is refused', (tester) async {
    await openNameScreen(tester);

    // Press Start without typing anything.
    await tester.tap(find.text('Start'));
    await tester.pump();

    expect(find.text('Your pet needs a name!'), findsOneWidget);

    // We are still on the name screen.
    expect(find.text('What will you call your pet?'), findsOneWidget);
  });

  testWidgets('a name longer than 12 letters is refused', (tester) async {
    await openNameScreen(tester);

    await tester.enterText(find.byType(TextFormField), 'Supercalifragilistic');
    await tester.tap(find.text('Start'));
    await tester.pump();

    expect(
      find.text('That is too long — 12 letters at most.'),
      findsOneWidget,
    );
  });

  testWidgets('a good name takes us to the home screen', (tester) async {
    await openNameScreen(tester);

    await tester.enterText(find.byType(TextFormField), 'Zara');
    await tester.tap(find.text('Start'));
    await finishRouteChange(tester);

    // The name screen is gone...
    expect(find.text('What will you call your pet?'), findsNothing);

    // ...and our pet's name is on the home screen.
    expect(find.text('Zara'), findsOneWidget);
    expect(find.text('Feed'), findsOneWidget);
  });

  testWidgets('spaces around the name are trimmed off', (tester) async {
    await openNameScreen(tester);

    await tester.enterText(find.byType(TextFormField), '   Bolu   ');
    await tester.tap(find.text('Start'));
    await finishRouteChange(tester);

    expect(find.text('Bolu'), findsOneWidget);
  });

  testWidgets('tapping a colour circle changes the choice', (tester) async {
    await openNameScreen(tester);

    // Only the chosen colour shows a tick, and the first one starts chosen.
    expect(find.byIcon(Icons.check), findsOneWidget);

    // There is one circle per colour in the list, each with its own key.
    for (final color in petColors) {
      expect(find.byKey(ValueKey(color)), findsOneWidget);
    }

    // Tap the third circle. The tick moves, so there is still only one.
    await tester.tap(find.byKey(ValueKey(petColors[2])));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);

    // And the tick is now inside the circle we tapped.
    expect(
      find.descendant(
        of: find.byKey(ValueKey(petColors[2])),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
  });
}
