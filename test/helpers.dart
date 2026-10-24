import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/main.dart';

/// Little helpers shared by all our test files, so each test stays short.

/// Tests run on a pretend screen that is only 800x600, which is smaller than
/// a real phone. This makes the pretend screen tall enough that every button
/// is visible and tappable.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Waits for a screen to finish sliding in or out.
///
/// We cannot use `pumpAndSettle` in this app: a happy pet bounces for ever, so
/// "wait until nothing is moving" would wait all day. So we pump by hand —
/// one frame to start the slide, a full second to let it finish (Material's
/// screen change takes 800ms), and one more frame to let the old screen be
/// tidied away.
Future<void> finishRouteChange(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pump();
}

/// Waits for a dialog box to fade in or out. Dialogs are much quicker than a
/// whole screen change — about 150ms — so we only need a short jump.
Future<void> finishDialog(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump();
}

/// Walks the app from the welcome screen all the way to the home screen,
/// naming the pet along the way.
Future<void> startWithPet(WidgetTester tester, [String name = 'Bolu']) async {
  await tester.pumpWidget(const PetPalApp());

  await tester.tap(find.text('Get started'));
  await finishRouteChange(tester);

  await tester.enterText(find.byType(TextFormField), name);
  await tester.tap(find.text('Start'));
  await finishRouteChange(tester);
}

/// Opens the app and taps Get started, so we land on the name screen.
Future<void> openNameScreen(WidgetTester tester) async {
  await tester.pumpWidget(const PetPalApp());
  await tester.tap(find.text('Get started'));
  await finishRouteChange(tester);
}
