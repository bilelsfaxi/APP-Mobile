import 'package:flutter/material.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quotidien')), 
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Objectifs du jour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Faire 3 sessions d\'entraînement'),
              trailing: Checkbox(value: false, onChanged: (_) {}),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Récompenser le chien après chaque ordre'),
              trailing: Checkbox(value: false, onChanged: (_) {}),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...List.generate(3, (i) => ListTile(
                leading: const Icon(Icons.circle, size: 16),
                title: Text('Événement ${i + 1}'),
                subtitle: Text('Heure : ${(8 + i)}:00'),
              )),
        ],
      ),
    );
  }
} 