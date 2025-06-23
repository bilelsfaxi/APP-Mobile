// progress_provider.dart 
import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../services/storage_service.dart';

class ProgressProvider extends ChangeNotifier {
  List<SessionModel> _sessions = [];
  List<SessionModel> get sessions => _sessions;
  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  Future<void> fetchSessions() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _sessions = await StorageService.fetchSessions();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
} 