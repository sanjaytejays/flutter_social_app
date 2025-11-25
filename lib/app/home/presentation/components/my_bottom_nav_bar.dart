import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      elevation: 3,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      indicatorColor: colorScheme.primary.withOpacity(0.2),

      // Animation duration for smooth switching
      animationDuration: const Duration(milliseconds: 600),

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.stars_outlined),
          selectedIcon: Icon(Icons.stars_rounded),
          label: 'MedAI',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_3_outlined),
          selectedIcon: Icon(Icons.groups_3_rounded),
          label: 'Community',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications_rounded),
          label: 'Notification',
        ),
      ],
    );
  }
}
