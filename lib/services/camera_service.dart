// camera_service.dart 
import 'package:camera/camera.dart';

class CameraService {
  CameraController? controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await controller!.initialize();
  }

  Future<void> dispose() async {
    await controller?.dispose();
  }
} 