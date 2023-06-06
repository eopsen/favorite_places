import 'package:favorite_places/screens/add_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Wyswietlany tekst "Nowe miejsce"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddPlaceScreen()));

    final titleFinder = find.text('Nowe miejsce');
    expect(titleFinder, findsOneWidget);
  });
}