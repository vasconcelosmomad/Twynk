import 'package:flutter/material.dart';
import '../themes/nomirro_colors.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color selectedColor =
        isDark ? NomirroColors.lilac : NomirroColors.primary;
    final Color unselectedColor =
        isDark ? Colors.white70 : NomirroColors.textSecondary;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search),
          label: 'Nearby',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt),
          label: 'Encounters',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),
      ],
    );
  }
}