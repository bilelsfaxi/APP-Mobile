// camera_widget.dart 
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class CameraWidget extends StatefulWidget {
  final CameraService cameraService;
  final void Function(String imagePath) onPictureTaken;
  const CameraWidget({super.key, required this.cameraService, required this.onPictureTaken});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    widget.cameraService.initialize().then((_) {
      setState(() { _loading = false; });
    });
  }

  @override
  void dispose() {
    widget.cameraService.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (widget.cameraService.controller != null && widget.cameraService.controller!.value.isInitialized) {
      final file = await widget.cameraService.controller!.takePicture();
      widget.onPictureTaken(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(widget.cameraService.controller!),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: FloatingActionButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }
} 