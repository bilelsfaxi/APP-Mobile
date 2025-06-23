// training_provider.dart 
import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class TrainingProvider extends ChangeNotifier {
  SessionModel? _currentSession;
  SessionModel? get currentSession => _currentSession;
  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  Future<void> startTrainingSession(String order, String imagePath) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      // Appel API IA pour analyse de posture
      final result = await ApiService.analyzeImage(imagePath, order);
      // Création de la session
      _currentSession = SessionModel(
        order: order,
        imagePath: imagePath,
        result: result,
        timestamp: DateTime.now(),
      );
      // Stockage du résultat dans Firebase
      await StorageService.saveSession(_currentSession!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearSession() {
    _currentSession = null;
    notifyListeners();
  }
} 