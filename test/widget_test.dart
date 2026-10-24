import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/main.dart';
import 'package:petpal/widgets/pet_view.dart';

void main() {
  testWidgets('home screen shows the pet, its name and three buttons',
      (tester) async {
    await tester.pumpWidget(const PetPalApp());

    // The pet is drawn on the screen.
    expect(find.byType(PetView), findsOneWidget);

    // Our pet's name is there.
    expect(find.text('Bolu'), findsOneWidget);

    // And all three button labels.
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
  });
}
