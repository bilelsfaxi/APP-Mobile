import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')), 
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? const Icon(Icons.person, size: 32) : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.displayName ?? 'Utilisateur', style: Theme.of(context).textTheme.titleLarge),
                      Text(user.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: const Text('Niveau'),
                  trailing: const Text('Débutant'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Badges'),
                  trailing: const Text('0'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Statistiques'),
                  trailing: const Text('À venir'),
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => auth.signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Déconnexion'),
                ),
              ),
            ] else ...[
              const Center(child: Text('Non connecté')),
            ],
          ],
        ),
      ),
    );
  }
} 