import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/main.dart';
import 'package:petpal/models/pet.dart';
import 'package:petpal/widgets/pet_view.dart';

/// Tests run on a pretend screen that is only 800x600, which is smaller than
/// a real phone. This makes the pretend screen tall enough that every button
/// is visible and tappable.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('feeding the pet makes the hunger number go down',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const PetPalApp());

    expect(find.text('40'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.restaurant));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('stats never go below 0', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const PetPalApp());

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.restaurant));
      await tester.pump();
    }

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('the mood word changes when the pet gets tired', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const PetPalApp());

    // Energy starts at 80, so the pet is happy.
    expect(find.text('Happy'), findsOneWidget);

    // Playing takes 15 energy each time: 80 -> 65 -> 50 -> 35 -> 20.
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byIcon(Icons.sports_esports));
      await tester.pump();
    }

    // Below 25 energy the pet is sleepy, whatever else is going on.
    expect(find.text('Sleepy'), findsOneWidget);
  });

  testWidgets('PetView can be drawn on its own for any mood', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PetView(mood: Mood.sad)),
      ),
    );

    expect(find.text('Sad'), findsOneWidget);
  });
}
