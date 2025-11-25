import 'package:flutter/material.dart';
import 'package:medcon/app/home/presentation/components/my_bottom_nav_bar.dart';
import 'package:medcon/app/home/presentation/components/my_drawer.dart';
import 'package:medcon/app/posts/presentation/screens/feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of pages to switch between
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FeedScreen(), // Feed screen
      const Center(child: Text("Search")), // Placeholder
      const Center(child: Text("Orders Page")), // Placeholder
      const Center(child: Text("Profile Page")), // Placeholder
      const Center(child: Text("Settings Page")), // Placeholder
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),

      // Connect the Bottom Nav Bar
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      // IndexedStack preserves the state of the pages (scroll position, etc.)
      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }
}
