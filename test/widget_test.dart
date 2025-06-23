// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dog_training_ai/main.dart';

void main() {
  testWidgets('Main navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Il faut utiliser DogTrainingApp, pas MyApp
    await tester.pumpWidget(const DogTrainingApp());

    // Vérifie que l'écran "Profil" est bien affiché au démarrage
    // Note: Le texte "Profil" est présent 2 fois (AppBar et BottomNavBar), donc on utilise findsWidgets
    expect(find.text('Profil'), findsWidgets);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
