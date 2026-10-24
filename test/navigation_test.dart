import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/main.dart';
import 'package:petpal/screens/about_screen.dart';
import 'package:petpal/screens/home_screen.dart';
import 'package:petpal/screens/name_screen.dart';
import 'package:petpal/screens/welcome_screen.dart';

import 'helpers.dart';

void main() {
  testWidgets('the three screens come in the right order', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const PetPalApp());

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(NameScreen), findsNothing);

    await tester.tap(find.text('Get started'));
    await finishRouteChange(tester);

    expect(find.byType(NameScreen), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Bolu');
    await tester.tap(find.text('Start'));
    await finishRouteChange(tester);

    expect(find.byType(HomeScreen), findsOneWidget);

    // pushReplacement threw the form away, so there is no going back to it.
    expect(find.byType(NameScreen), findsNothing);
  });

  testWidgets('the info button opens the stats screen', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    await tester.tap(find.byIcon(Icons.info_outline));
    await finishRouteChange(tester);

    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('All about Bolu'), findsOneWidget);
  });

  testWidgets('a treat from the stats screen feeds the pet', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // Hunger starts at 40.
    expect(find.text('40'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.info_outline));
    await finishRouteChange(tester);

    // This pops the screen AND sends the word 'treat' back with it.
    await tester.tap(find.text('Give a treat'));
    await finishRouteChange(tester);

    // Back on the home screen, and the treat counted as a feed: 40 - 25 = 15.
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Bolu loved that treat!'), findsOneWidget);
  });

  testWidgets('coming back without a treat changes nothing', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    await tester.tap(find.byIcon(Icons.info_outline));
    await finishRouteChange(tester);

    await tester.tap(find.text('Back to my pet'));
    await finishRouteChange(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Bolu loved that treat!'), findsNothing);
  });
}
