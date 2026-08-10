import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/plants/plant_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';

/// App shell hosting the Dashboard / Plants / Profile / Settings tabs behind
/// a persistent bottom navigation bar. Each tab keeps its own state via
/// [IndexedStack] rather than being rebuilt on every switch.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _goToPlantsTab() => setState(() => _selectedIndex = 1);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      DashboardScreen(onViewPlants: _goToPlantsTab),
      const PlantListScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined),
            label: 'Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
