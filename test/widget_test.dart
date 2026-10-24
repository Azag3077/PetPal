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

  testWidgets('the clock makes the pet hungrier all by itself', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const PetPalApp());

    expect(find.text('40'), findsOneWidget);

    // In a test we can jump forward in time instead of really waiting.
    await tester.pump(const Duration(seconds: 3));

    // One tick adds 5 to hunger.
    expect(find.text('45'), findsOneWidget);
  });

  testWidgets('a very hungry pet gets a warning message', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const PetPalApp());

    // Hunger starts at 40 and grows by 5 every 3 seconds.
    // After 8 ticks it reaches 80, which counts as starving.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(seconds: 3));
    }

    // Give the message one frame to slide in.
    await tester.pump();

    expect(find.text('Bolu is starving! Please feed your pet.'),
        findsOneWidget);
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
