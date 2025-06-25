import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/training_screen.dart';
import 'screens/daily_screen.dart';
import 'screens/progress_screen.dart';
import 'package:provider/provider.dart';
import 'providers/training_provider.dart';
import 'providers/progress_provider.dart';

void main() {
  runApp(const DogTrainingApp());
}

class DogTrainingApp extends StatelessWidget {
  const DogTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
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
  int _currentIndex = 1;
  final List<Widget> _screens = const [
    ProfileScreen(),
    TrainingScreen(),
    DailyScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          border: Border.all(color: const Color(0xFFE0E6F3), width: 1.5),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blueAccent.withOpacity(0.4),
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.center_focus_strong), label: 'Training'),
            BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Daily'),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), label: 'Progress'),
          ],
        ),
      ),
    );
  }
}
