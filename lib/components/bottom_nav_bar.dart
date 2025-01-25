import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF262626),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Чат',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Аналитика',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Авторизация',
        ),
      ],
    );
  }
}
