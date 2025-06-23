import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progression')), 
      body: Consumer<ProgressProvider>(
        builder: (context, progress, _) {
          return RefreshIndicator(
            onRefresh: progress.fetchSessions,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Graphique de progression', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ProgressChart(
                  data: progress.sessions.map((s) => (s.result['score'] ?? 0.0) as double).toList(),
                ),
                const SizedBox(height: 32),
                const Text('Historique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (progress.loading)
                  const Center(child: CircularProgressIndicator()),
                if (progress.error != null)
                  Text('Erreur : ${progress.error}', style: const TextStyle(color: Colors.red)),
                ...progress.sessions.map((s) => ListTile(
                      title: Text(s.order),
                      subtitle: Text(s.timestamp.toString()),
                      trailing: Text('Score: ${(s.result['score'] ?? 0.0).toString()}'),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
} 