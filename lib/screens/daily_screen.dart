import 'package:flutter/material.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Progression du jour (nouveau bloc)
          const _ProgressCard(
            completed: 2,
            goal: 3,
            progress: 2 / 3,
            time: '45m',
            accuracy: 89,
          ),
          const SizedBox(height: 24),
          // Résumé du jour
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: const Color(0xFFF6F8FF),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's Highlights",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  const SizedBox(height: 4),
                  const Text(
                    'Your achievements and progress summary',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatColumn(
                        label: 'Most practiced posture',
                        value: '🐕 Sitting',
                        valueColor: Colors.orange[800],
                      ),
                      _StatColumn(
                        label: 'Sessions completed',
                        value: '2/3',
                        valueColor: Colors.blue[800],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatColumn(
                        label: 'Best accuracy',
                        value: '94%',
                        valueColor: Colors.green[700],
                      ),
                      _StatColumn(
                        label: 'Time remaining',
                        value: '~15min',
                        valueColor: Colors.blue[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatColumn(
                        label: 'Longest streak',
                        value: '7 correct in a row',
                        valueColor: Colors.orange[700],
                      ),
                      _StatColumn(
                        label: 'Progress this week',
                        value: '12/21 sessions',
                        valueColor: Colors.purple[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Planning du jour
          Text("Today's Schedule",
              style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const SizedBox(height: 2),
          const Text('Your planned training sessions for today',
              style: TextStyle(color: Colors.black54, fontSize: 15)),
          const SizedBox(height: 18),
          const _SessionCard(
            title: 'Morning Session',
            hour: '08:00',
            postures: ['🐕 Sitting', '🦴 Standing'],
            status: SessionStatus.completed,
          ),
          const SizedBox(height: 12),
          const _SessionCard(
            title: 'Afternoon Session',
            hour: '14:00',
            postures: ['😴 Lying'],
            status: SessionStatus.completed,
          ),
          const SizedBox(height: 12),
          const _SessionCard(
            title: 'Evening Session',
            hour: '19:00',
            postures: ['👥 Heel'],
            status: SessionStatus.pending,
          ),
        ],
      ),
    );
  }
}

enum SessionStatus { completed, pending }

class _SessionCard extends StatelessWidget {
  final String title;
  final String hour;
  final List<String> postures;
  final SessionStatus status;
  const _SessionCard({
    required this.title,
    required this.hour,
    required this.postures,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == SessionStatus.completed;
    final bgColor = isCompleted ? Colors.green[50] : const Color(0xFFF6F8FF);
    final borderColor = isCompleted ? Colors.green[200] : Colors.blue[100];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor ?? Colors.transparent, width: 2),
      ),
      color: bgColor,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.radio_button_checked,
                  color: isCompleted ? Colors.green : Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCompleted
                            ? Colors.green[900]
                            : Colors.blue[900])),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isCompleted ? '✓ Completed' : 'Pending',
                    style: TextStyle(
                        color:
                            isCompleted ? Colors.green[900] : Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(hour,
                style: const TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('Postures:',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(width: 6),
                ...postures.map((p) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(p, style: const TextStyle(fontSize: 15)),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _StatColumn(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: valueColor)),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int goal;
  final double progress;
  final String time;
  final int accuracy;
  const _ProgressCard({
    required this.completed,
    required this.goal,
    required this.progress,
    required this.time,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color(0xFF16A34A),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.track_changes, color: Colors.white, size: 32),
                SizedBox(width: 10),
                Text("Today's Progress",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Keep up the great work!',
                style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Daily Goal',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                const Spacer(),
                Text('$completed/$goal sessions',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              goal - completed > 0
                  ? '${goal - completed} more session to reach your daily goal!'
                  : 'Goal reached! 🎉',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
