import 'package:flutter/material.dart';
import 'package:testapp/screens/mood_screen.dart';
import 'package:testapp/screens/nutrition_screen.dart';
import 'package:testapp/screens/plan_screen.dart';

import '../utils/custom_colors.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NutritionScreen(),
    const PlanScreen(),
    const MoodScreen(),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}