// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String baseUrl = 'https://bilelsf-api-deployment-app.hf.space';

  static Uint8List? _annotatedWebVideoBytes;
  static String? _webVideoUrl; // Pour web
  static VideoPlayerController? _videoController; // Pour mobile

  static Future<Map<String, dynamic>> analyzeImage(
      String imagePath, String order) async {
    final url = Uri.parse('$baseUrl/yolo/predict');
    var request = http.MultipartRequest('POST', url)
      ..fields['order'] = order
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));
    final response = await request.send();
    final contentType = response.headers['content-type'] ?? '';
    if (response.statusCode == 200 && contentType.startsWith('image/')) {
      final bytes = await response.stream.toBytes();
      print(bytes);
      return {'annotated_image_bytes': bytes};
    } else {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return json.decode(respStr) as Map<String, dynamic>;
    }
  }

  static Future<Map<String, dynamic>> analyzeImageBytes(
      Uint8List bytes, String order) async {
    final url = Uri.parse('$baseUrl/yolo/predict');
    var request = http.MultipartRequest('POST', url)
      ..fields['order'] = order
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    final response = await request.send();
    final contentType = response.headers['content-type'] ?? '';
    if (response.statusCode == 200 && contentType.startsWith('image/')) {
      final imgBytes = await response.stream.toBytes();
      print(imgBytes);
      return {'annotated_image_bytes': imgBytes};
    } else {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return json.decode(respStr) as Map<String, dynamic>;
    }
  }

  static Future<Map<String, dynamic>> analyzeVideo(
      String videoPath, String order) async {
    final url = Uri.parse('$baseUrl/yolo/predict-video');
    var request = http.MultipartRequest('POST', url)
      ..fields['order'] = order
      ..files.add(await http.MultipartFile.fromPath('file', videoPath));
    final response = await request.send();
    final contentType = response.headers['content-type'] ?? '';
    print('Content-Type: $contentType');
    if (response.statusCode == 200 && contentType.startsWith('video/')) {
      final videoBytes = await response.stream.toBytes();
      return {'annotated_video_bytes': videoBytes};
    } else {
      final respStr = await response.stream.bytesToString();
      return json.decode(respStr) as Map<String, dynamic>;
    }
  }

  static Future<Map<String, dynamic>> analyzeVideoBytes(
      Uint8List bytes, String order) async {
    final url = Uri.parse('$baseUrl/yolo/predict-video');
    var request = http.MultipartRequest('POST', url)
      ..fields['order'] = order
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'video.mp4',
        contentType: MediaType('video', 'mp4'),
      ));
    final response = await request.send();
    final contentType = response.headers['content-type'] ?? '';
    print('Content-Type: $contentType');
    if (response.statusCode == 200 && contentType.startsWith('video/')) {
      final videoBytes = await response.stream.toBytes();
      return {'annotated_video_bytes': videoBytes};
    } else {
      final respStr = await response.stream.bytesToString();
      return json.decode(respStr) as Map<String, dynamic>;
    }
  }
}
