// progress_provider.dart
import 'package:flutter/material.dart';
import '../models/session_model.dart';
import 'training_provider.dart';

class ProgressProvider extends ChangeNotifier {
  List<SessionModel> _sessions = [];
  List<SessionModel> get sessions => _sessions;
  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  void fetchSessions(TrainingProvider trainingProvider) {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _sessions = List.from(trainingProvider.localSessions);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
