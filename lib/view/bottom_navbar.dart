import 'package:cloudocz/view/profile_view.dart';
import 'package:cloudocz/view/tasks_view.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String token;

  BottomNavBar({super.key, required this.token});

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      TaskListScreen(token: token),
      ProfileScreen(),
    ];

    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, _) {
          return _screens[selectedIndex];
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, _) {
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => _selectedIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
