// api_service.dart 
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bilelsf-api-deployment-app.hf.space';

  static Future<Map<String, dynamic>> analyzeImage(String imagePath, String order) async {
    final url = Uri.parse('$baseUrl/yolo/predict');
    var request = http.MultipartRequest('POST', url)
      ..fields['order'] = order
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return json.decode(respStr) as Map<String, dynamic>;
    } else {
      throw Exception('Erreur API: ${response.statusCode}');
    }
  }
} 