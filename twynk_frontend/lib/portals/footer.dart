import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color selectedColor =
        isDark ? colorScheme.secondary : colorScheme.primary;
    final Color unselectedColor = isDark
        ? Colors.white70
        : colorScheme.onSurface.withValues(alpha: 0.7);

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