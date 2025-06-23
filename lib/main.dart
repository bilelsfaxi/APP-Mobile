import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/profile_screen.dart';
import 'screens/training_screen.dart';
import 'screens/daily_screen.dart';
import 'screens/progress_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/training_provider.dart';
import 'providers/progress_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DogTrainingApp());
}

class DogTrainingApp extends StatelessWidget {
  const DogTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TrainingProvider()),
              ChangeNotifierProvider(create: (_) => ProgressProvider()),
            ],
            child: MaterialApp(
              title: 'Dog Training AI',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.indigo,
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),
              // home: auth.user == null ? const AuthScreen() : const MainNavigation(), // Authentification désactivée pour test
              home: const MainNavigation(),
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    ProfileScreen(),
    TrainingScreen(),
    DailyScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Entraînement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Quotidien',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progression',
          ),
        ],
      ),
    );
  }
}
