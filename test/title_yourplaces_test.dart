import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:favorite_places/screens/places.dart';

void main() {
  testWidgets('Wyswietlany tekst "Twoje miejsca"', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PlacesScreen(),
        ),
      ),
    );

    expect(find.text("Twoje miejsca"), findsOneWidget);
  });
}
