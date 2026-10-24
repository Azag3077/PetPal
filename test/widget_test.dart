import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/models/pet.dart';
import 'package:petpal/widgets/pet_painter.dart';
import 'package:petpal/widgets/pet_view.dart';
import 'package:petpal/widgets/play_area.dart';

import 'helpers.dart';

void main() {
  testWidgets('feeding the pet makes the hunger number go down',
      (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    expect(find.text('40'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.restaurant));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('stats never go below 0', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.restaurant));
      await tester.pump();
    }

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('the mood word changes when the pet gets tired', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

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
    await startWithPet(tester);

    expect(find.text('40'), findsOneWidget);

    // In a test we can jump forward in time instead of really waiting.
    await tester.pump(const Duration(seconds: 6));

    // One tick adds 5 to hunger.
    expect(find.text('45'), findsOneWidget);
  });

  testWidgets('a very hungry pet gets a warning message', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // Hunger starts at 40 and grows by 5 every 6 seconds.
    // After 8 ticks it reaches 80, which counts as starving.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(seconds: 6));
    }

    // Give the message one frame to slide in.
    await tester.pump();

    expect(find.text('Bolu is starving! Please feed your pet.'),
        findsOneWidget);
  });

  testWidgets('feeding the pet shakes it sideways', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // The pet is now painted, so we look for the CustomPaint inside PetView.
    final petBody = find
        .descendant(
          of: find.byType(PetView),
          matching: find.byType(CustomPaint),
        )
        .first;

    final startX = tester.getCenter(petBody).dx;

    await tester.tap(find.byIcon(Icons.restaurant));

    // Jump a little way into the 400ms shake and check the pet has slid
    // off to one side.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(tester.getCenter(petBody).dx, isNot(startX));
  });

  testWidgets('the pet can be dragged across the play area', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    final startX = tester.getTopLeft(find.byType(PetView)).dx;

    // Slide a finger to the right, starting on the pet.
    await tester.drag(find.byType(PetView), const Offset(60, 0));
    await tester.pump();

    // The pet followed the finger. (A real finger always wobbles a little
    // before a drag counts as a drag, so we check it moved right rather than
    // checking an exact number of pixels.)
    expect(tester.getTopLeft(find.byType(PetView)).dx, greaterThan(startX));
  });

  testWidgets('the pet cannot be dragged off the grass', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // Drag much further left than the play area is wide.
    await tester.drag(find.byType(PetView), const Offset(-2000, 0));
    await tester.pump();

    final stoppedAt = tester.getTopLeft(find.byType(PetView)).dx;

    // The pet should never be left of the grass it is standing on.
    expect(stoppedAt, greaterThanOrEqualTo(
      tester.getTopLeft(find.byType(PlayArea)).dx,
    ));

    // Dragging left again changes nothing, because it is already at the edge.
    await tester.drag(find.byType(PetView), const Offset(-2000, 0));
    await tester.pump();

    expect(tester.getTopLeft(find.byType(PetView)).dx, stoppedAt);
  });

  testWidgets('tapping the pet makes it giggle and get happier',
      (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // Happiness starts at 70.
    expect(find.text('70'), findsOneWidget);

    await tester.tap(find.byType(PetView));
    await tester.pump();

    expect(find.text('75'), findsOneWidget);
  });

  testWidgets('PetView can be drawn on its own for any mood', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PetView(mood: Mood.sad)),
      ),
    );

    expect(find.text('Sad'), findsOneWidget);
  });

  testWidgets('the pet is painted, not built from boxes', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PetView(mood: Mood.happy)),
      ),
    );

    // Find the CustomPaint that belongs to us and check it holds a PetPainter.
    final painted = tester.widgetList<CustomPaint>(
      find.descendant(
        of: find.byType(PetView),
        matching: find.byType(CustomPaint),
      ),
    );

    expect(painted.any((p) => p.painter is PetPainter), isTrue);
  });

  test('the painter only redraws when something actually changed', () {
    final happy = PetPainter(mood: Mood.happy, bodyColor: Colors.orange);
    final sameAgain = PetPainter(mood: Mood.happy, bodyColor: Colors.orange);
    final sad = PetPainter(mood: Mood.sad, bodyColor: Colors.grey);

    expect(sameAgain.shouldRepaint(happy), isFalse);
    expect(sad.shouldRepaint(happy), isTrue);
  });
}
