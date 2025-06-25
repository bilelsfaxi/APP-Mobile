import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../providers/training_provider.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Weekly Progress Card
          const _WeeklyProgressCard(),
          const SizedBox(height: 24),
          // Stats Cards Row
          Row(
            children: const [
              Expanded(
                  child: _StatCard(
                      icon: Icons.calendar_today,
                      label: 'Total Sessions',
                      value: '18',
                      color: Colors.blue)),
              SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.track_changes,
                      label: 'Successful Poses',
                      value: '52',
                      color: Colors.green)),
              SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.access_time,
                      label: 'Avg Duration',
                      value: '9m',
                      color: Colors.orange)),
              SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.trending_up,
                      label: 'Trend',
                      value: 'Improving',
                      color: Colors.purple)),
            ],
          ),
          const SizedBox(height: 28),
          // Daily Success Rate
          const _DailySuccessRate(),
          const SizedBox(height: 28),
          // Detailed Statistics Table
          const _DetailedStatisticsTable(),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9333EA), Color(0xFFF43F5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(
                  child: Text('Weekly Progress',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22)),
                ),
                Icon(Icons.trending_up, color: Colors.white, size: 32),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Your training journey this week',
                style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: const [
                        Text('96%',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28)),
                        SizedBox(height: 4),
                        Text('Success Rate',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: const [
                        Text('+23%',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28)),
                        SizedBox(height: 4),
                        Text('vs Last Week',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.black54, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _DailySuccessRate extends StatelessWidget {
  const _DailySuccessRate();

  @override
  Widget build(BuildContext context) {
    final days = [
      {
        'day': 'Mon',
        'accuracy': 89,
        'success': '8/9',
        'duration': '25min',
        'color': Colors.amber
      },
      {
        'day': 'Tue',
        'accuracy': 83,
        'success': '5/6',
        'duration': '18min',
        'color': Colors.amber
      },
      {
        'day': 'Wed',
        'accuracy': 100,
        'success': '12/12',
        'duration': '32min',
        'color': Colors.green
      },
      {
        'day': 'Thu',
        'accuracy': 67,
        'success': '2/3',
        'duration': '12min',
        'color': Colors.red
      },
      {
        'day': 'Fri',
        'accuracy': 100,
        'success': '9/9',
        'duration': '28min',
        'color': Colors.green
      },
      {
        'day': 'Sat',
        'accuracy': 100,
        'success': '6/6',
        'duration': '20min',
        'color': Colors.green
      },
      {
        'day': 'Sun',
        'accuracy': 111,
        'success': '10/9',
        'duration': '30min',
        'color': Colors.green
      },
    ];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      color: const Color(0xFFF6F8FF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Success Rate',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 2),
            const Text('Your accuracy improvement over the past 7 days',
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 18),
            ...days.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 36,
                          child: Text(d['day'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 4),
                      SizedBox(
                          width: 80,
                          child: Text('${d['accuracy']}% accuracy',
                              style: TextStyle(
                                  color: d['color'] as Color,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (d['accuracy'] as int) / 100.0,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                d['color'] as Color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                          width: 40,
                          child: Text(d['success'] as String,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 13))),
                      const SizedBox(width: 8),
                      SizedBox(
                          width: 40,
                          child: Text(d['duration'] as String,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 13))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _DetailedStatisticsTable extends StatelessWidget {
  const _DetailedStatisticsTable();

  @override
  Widget build(BuildContext context) {
    final days = [
      {
        'day': 'Mon',
        'sessions': 3,
        'successes': 8,
        'duration': '25min',
        'accuracy': 89
      },
      {
        'day': 'Tue',
        'sessions': 2,
        'successes': 5,
        'duration': '18min',
        'accuracy': 83
      },
      {
        'day': 'Wed',
        'sessions': 4,
        'successes': 12,
        'duration': '32min',
        'accuracy': 100
      },
      {
        'day': 'Thu',
        'sessions': 1,
        'successes': 2,
        'duration': '12min',
        'accuracy': 67
      },
      {
        'day': 'Fri',
        'sessions': 3,
        'successes': 9,
        'duration': '28min',
        'accuracy': 100
      },
      {
        'day': 'Sat',
        'sessions': 2,
        'successes': 6,
        'duration': '20min',
        'accuracy': 100
      },
      {
        'day': 'Sun',
        'sessions': 3,
        'successes': 10,
        'duration': '30min',
        'accuracy': 111
      },
    ];
    Color? accuracyColor(int acc) {
      if (acc >= 100) return Colors.green[100];
      if (acc >= 90) return Colors.amber[100];
      if (acc >= 80) return Colors.amber[100];
      return Colors.red[100];
    }

    Color? accuracyTextColor(int acc) {
      if (acc >= 100) return Colors.green[700];
      if (acc >= 90) return Colors.amber[800];
      if (acc >= 80) return Colors.amber[800];
      return Colors.red[700];
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      color: const Color(0xFFF6F8FF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detailed Statistics',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 2),
            const Text('Comprehensive breakdown of your training data',
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 18),
            Row(
              children: const [
                SizedBox(
                    width: 36,
                    child: Text('Day',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 24),
                Expanded(
                    child: Text('Sessions',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Successes',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Duration',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Accuracy',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 8),
            ...days.map((d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 36, child: Text(d['day'] as String)),
                      const SizedBox(width: 24),
                      Expanded(
                          child: Text('${d['sessions']}',
                              style: const TextStyle(color: Colors.black87))),
                      Expanded(
                          child: Text('${d['successes']}',
                              style: const TextStyle(color: Colors.green))),
                      Expanded(
                          child: Text(d['duration'] as String,
                              style: const TextStyle(color: Colors.black54))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: accuracyColor(d['accuracy'] as int),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${d['accuracy']}%',
                            style: TextStyle(
                              color: accuracyTextColor(d['accuracy'] as int),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
