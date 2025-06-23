import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/training_provider.dart';
import '../widgets/camera_widget.dart';
import '../services/camera_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final training = Provider.of<TrainingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Entraînement IA')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedOrder,
              hint: const Text('Sélectionner un ordre'),
              items: _orders.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => _selectedOrder = v),
            ),
          ),
          Expanded(
            child: CameraWidget(
              cameraService: _cameraService,
              onPictureTaken: (imagePath) async {
                if (_selectedOrder != null) {
                  await training.startTrainingSession(_selectedOrder!, imagePath);
                  if (training.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : ${training.error}')),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Résultat IA'),
                        content: Text(training.currentSession?.result.toString() ?? 'Aucun résultat'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sélectionnez un ordre avant de prendre une photo.')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
} 