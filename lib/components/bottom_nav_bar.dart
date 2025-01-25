import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  void _showAuthRequiredSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Для доступа требуется авторизация'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        if (index != 2 && !chatProvider.isAuthenticated) {
          _showAuthRequiredSnackBar(context);
          return;
        }
        onItemTapped(index);
      },
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
