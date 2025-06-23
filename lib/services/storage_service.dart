// storage_service.dart 
import 'package:firebase_database/firebase_database.dart';
import '../models/session_model.dart';

class StorageService {
  static final _db = FirebaseDatabase.instance.ref('sessions');

  static Future<void> saveSession(SessionModel session) async {
    await _db.push().set(session.toJson());
  }

  static Future<List<SessionModel>> fetchSessions() async {
    final snapshot = await _db.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.values
          .map((e) => SessionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
} 