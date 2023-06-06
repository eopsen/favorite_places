import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/screens/add_place.dart';

void main() {
  testWidgets('Wpisanie tekstu do pola "Nazwa"', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AddPlaceScreen(),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, 'Example Place');

    expect(find.text('Example Place'), findsOneWidget);
  });
}
