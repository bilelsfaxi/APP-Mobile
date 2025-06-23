// session_model.dart 

class SessionModel {
  final String order;
  final String imagePath;
  final Map<String, dynamic> result;
  final DateTime timestamp;

  SessionModel({
    required this.order,
    required this.imagePath,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'order': order,
        'imagePath': imagePath,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
        order: json['order'] ?? '',
        imagePath: json['imagePath'] ?? '',
        result: Map<String, dynamic>.from(json['result'] ?? {}),
        timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      );
} 