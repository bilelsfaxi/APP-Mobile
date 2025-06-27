// ignore: implementation_imports
import 'dart:ui' as ui;
import 'package:web/web.dart' as web;

void registerWebViewFactory(String viewType, dynamic Function(int) cb) {
  // platformViewRegistry n'est plus accessible sur Flutter web récent.
  // Utilisez package:web pour manipuler le DOM si besoin.
  // Cette fonction est laissée vide pour compatibilité.
}
