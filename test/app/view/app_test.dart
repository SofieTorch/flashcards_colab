import 'package:flashcards_colab/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const AppView());
      expect(find.byType(Center), findsOneWidget);
    });
  });
}
