import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        children: const [
          ProfileHeader(
            username: 'sfaxi.bilel',
            level: 3,
            progress: 2 / 3,
            challenges: 2,
            challengesGoal: 3,
            avatarUrl: null,
          ),
          SizedBox(height: 24),
          ProfileStats(
            sessions: 25,
            challenges: 8,
            streak: 5,
            accuracy: 87,
          ),
          SizedBox(height: 24),
          AchievementsGrid(
            unlocked: [true, true, true, false, false, false],
          ),
          SizedBox(height: 24),
          NextAchievementCard(),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String username;
  final int level;
  final double progress;
  final int challenges;
  final int challengesGoal;
  final String? avatarUrl;
  const ProfileHeader({
    super.key,
    required this.username,
    required this.level,
    required this.progress,
    required this.challenges,
    required this.challengesGoal,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B50EC), Color(0xFF4F8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null
                    ? const Icon(Icons.account_circle,
                        size: 48, color: Color(0xFF2B50EC))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Level 3 Dog Trainer',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text('L$level',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Progress to Level ${level + 1}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('$challenges/$challengesGoal challenges',
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileStats extends StatelessWidget {
  final int sessions;
  final int challenges;
  final int streak;
  final int accuracy;
  const ProfileStats(
      {super.key,
      required this.sessions,
      required this.challenges,
      required this.streak,
      required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(
          icon: Icons.calendar_today,
          value: sessions.toString(),
          label: 'Total Sessions',
          color: const Color(0xFF2B50EC),
        ),
        _StatCard(
          icon: Icons.emoji_events,
          value: challenges.toString(),
          label: 'Challenges',
          color: const Color(0xFF1DBF73),
        ),
        _StatCard(
          icon: Icons.flash_on,
          value: streak.toString(),
          label: 'Day Streak',
          color: const Color(0xFFFFA726),
        ),
        _StatCard(
          icon: Icons.star,
          value: '$accuracy%',
          label: 'Accuracy',
          color: const Color(0xFF8E24AA),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class AchievementsGrid extends StatelessWidget {
  final List<bool> unlocked;
  const AchievementsGrid({super.key, required this.unlocked});

  static const List<String> titles = [
    'First Steps',
    'Precision',
    'On Fire',
    'Expert',
    'Veteran',
    'Master'
  ];
  static const List<String> icons = ['👣', '🎯', '🔥', '🥇', '🏅', '👑'];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900])),
            const SizedBox(height: 4),
            const Text(
              'Unlock badges by completing challenges and training sessions',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: 6,
              itemBuilder: (context, i) {
                final isUnlocked = unlocked[i];
                return Container(
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.yellow[200] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: isUnlocked ? Colors.amber : Colors.grey.shade400,
                        width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(icons[i], style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text(
                        titles[i],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.indigo[900] : Colors.grey,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NextAchievementCard extends StatelessWidget {
  const NextAchievementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child:
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Next Achievement',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo)),
                  SizedBox(height: 4),
                  Text('Expert',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 2),
                  Text('Complete 10+ challenges',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
