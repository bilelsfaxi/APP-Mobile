import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import 'dart:async';

class Challenge {
  final String emoji;
  final String title;
  final String difficulty;
  final String description;
  final int progress;
  final int goal;
  const Challenge({
    required this.emoji,
    required this.title,
    required this.difficulty,
    required this.description,
    this.progress = 0,
    this.goal = 3,
  });
}

const List<Challenge> kChallenges = [
  Challenge(
    emoji: '🐕‍🦺',
    title: 'Sitting',
    difficulty: 'Easy',
    description: 'Get your dog to sit on command',
  ),
  Challenge(
    emoji: '🦴',
    title: 'Standing',
    difficulty: 'Easy',
    description: 'Get your dog to stand upright',
  ),
  Challenge(
    emoji: '😴',
    title: 'Lying Down',
    difficulty: 'Medium',
    description: 'Get your dog to lie down',
  ),
];

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final CameraService _cameraService = CameraService();
  String? _selectedOrder;
  final List<String> _orders = [
    'Assis',
    'Couché',
    'Debout',
    'Reste',
    'Viens',
  ];
  File? _imageFile;
  File? _videoFile;
  bool _cameraActive = false;
  String? _apiResult;
  bool _loading = false;
  int _selectedChallenge = 0;

  // Ajout pour le mode live
  bool _liveMode = false;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  void _startLiveDetection() {
    setState(() {
      _liveMode = true;
      _startTime = DateTime.now();
      _elapsed = Duration.zero;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(_startTime!);
      });
    });
  }

  void _stopLiveDetection() {
    setState(() {
      _liveMode = false;
    });
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _videoFile = null;
        _apiResult = null;
        _cameraActive = false;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _imageFile = null;
        _apiResult = null;
        _cameraActive = false;
      });
    }
  }

  Future<void> _activateCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _videoFile = null;
        _apiResult = null;
        _cameraActive = false;
      });
    }
  }

  Future<void> _sendToApi() async {
    setState(() {
      _loading = true;
      _apiResult = null;
    });
    try {
      final challenge = kChallenges[_selectedChallenge];
      if (_imageFile != null) {
        final result =
            await ApiService.analyzeImage(_imageFile!.path, challenge.title);
        setState(() {
          _apiResult = result.toString();
        });
      } else if (_videoFile != null) {
        final result =
            await ApiService.analyzeVideo(_videoFile!.path, challenge.title);
        setState(() {
          _apiResult = result.toString();
        });
      }
    } catch (e) {
      setState(() {
        _apiResult = 'Erreur API: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = kChallenges[_selectedChallenge];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        children: [
          AvailableChallenges(
            selected: _selectedChallenge,
            onSelect: (i) => setState(() => _selectedChallenge = i),
          ),
          const SizedBox(height: 18),
          CurrentChallengeCard(
            challenge: challenge,
            onStartTraining: _startLiveDetection,
          ),
          const SizedBox(height: 24),
          _liveMode
              ? LiveDetectionCard(
                  elapsed: _elapsed,
                  onStop: _stopLiveDetection,
                  onDetect: () {
                    // Appelle l'API ou la détection ici
                  },
                )
              : CameraCard(
                  imageFile: _imageFile,
                  videoFile: _videoFile,
                  onUploadPhoto: _pickImage,
                  onUploadVideo: _pickVideo,
                  onSendToApi: (_imageFile != null || _videoFile != null)
                      ? _sendToApi
                      : null,
                  apiResult: _apiResult,
                  loading: _loading,
                ),
        ],
      ),
    );
  }
}

class AvailableChallenges extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const AvailableChallenges(
      {super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Challenges',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Color(0xFF2B50EC))),
            const SizedBox(height: 2),
            const Text('Select a challenge to work on',
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 18),
            ...List.generate(kChallenges.length, (i) {
              final c = kChallenges[i];
              final isSelected = i == selected;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF1F6FF) : Colors.white,
                    border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2B50EC)
                            : Colors.grey.shade200,
                        width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(c.emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Text(c.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            const SizedBox(width: 10),
                            Text(c.difficulty,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13)),
                            const Spacer(),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B50EC),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Current',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(c.description,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Progress: ${c.progress}/${c.goal}',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 13)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: c.progress / c.goal,
                                minHeight: 6,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    isSelected
                                        ? const Color(0xFF2B50EC)
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${((c.progress / c.goal) * 100).toInt()}%',
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CurrentChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onStartTraining;
  const CurrentChallengeCard(
      {super.key, required this.challenge, required this.onStartTraining});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B50EC), Color(0xFF4F8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              const Text('Current Challenge',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Text(challenge.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const SizedBox(height: 4),
          Text(challenge.description,
              style: const TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text('Progress',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: challenge.progress / challenge.goal,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              Text('${challenge.progress}/${challenge.goal}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(challenge.difficulty,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2B50EC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  elevation: 0,
                ),
                onPressed: onStartTraining,
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('Start Training',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CameraCard extends StatelessWidget {
  final File? imageFile;
  final File? videoFile;
  final VoidCallback onUploadPhoto;
  final VoidCallback onUploadVideo;
  final VoidCallback? onSendToApi;
  final String? apiResult;
  final bool loading;
  const CameraCard(
      {super.key,
      this.imageFile,
      this.videoFile,
      required this.onUploadPhoto,
      required this.onUploadVideo,
      this.onSendToApi,
      this.apiResult,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    Widget preview;
    if (imageFile != null) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(imageFile!,
            height: 180, fit: BoxFit.cover, width: double.infinity),
      );
    } else if (videoFile != null) {
      preview = Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
            child: Icon(Icons.videocam, color: Colors.grey, size: 48)),
      );
    } else {
      preview = Column(
        children: [
          Icon(Icons.camera_alt, color: Colors.grey[400], size: 48),
          const SizedBox(height: 10),
          const Text('Camera not active',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
        child: Column(
          children: [
            preview,
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onUploadPhoto,
                    icon: const Icon(Icons.upload, size: 20),
                    label: const Text('Upload Photo',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onUploadVideo,
                    icon: const Icon(Icons.video_library, size: 20),
                    label: const Text('Upload Video',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (onSendToApi != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B50EC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: loading ? null : onSendToApi,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send, size: 20),
                  label: const Text('Send to AI',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            if (apiResult != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(apiResult!,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF2B50EC))),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Nouveau widget LiveDetectionCard
class LiveDetectionCard extends StatelessWidget {
  final Duration elapsed;
  final VoidCallback onStop;
  final VoidCallback onDetect;
  const LiveDetectionCard({
    super.key,
    required this.elapsed,
    required this.onStop,
    required this.onDetect,
  });

  String get formattedTime {
    final m = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.camera_alt, color: Colors.black87),
                const SizedBox(width: 8),
                const Text('Live Detection',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87)),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    elevation: 0,
                  ),
                  onPressed: onDetect,
                  icon: const Icon(Icons.flash_on, size: 20),
                  label: const Text('Detect',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Real-time posture detection',
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2233),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: Colors.white38, size: 64),
                  const SizedBox(height: 12),
                  const Text('Camera Active',
                      style: TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('LIVE',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Time: $formattedTime',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: onStop,
                icon: const Icon(Icons.stop, size: 20),
                label: const Text('Stop Training',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
