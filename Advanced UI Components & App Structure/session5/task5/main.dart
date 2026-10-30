
import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicScreen(),
    );
  }
}

// Main Music Screen
class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = [
    const SongsScreen(),
    const AlbumsScreen(),
    const ProfileScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: screens[selectedIndex],

      // Custom Bottom Navigation Widget
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}

// Songs Screen
class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 90,
            color: Colors.green,
          ),
          SizedBox(height: 15),
          Text(
            "Songs Screen",
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}

// Albums Screen
class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.album,
            size: 90,
            color: Colors.purple,
          ),
          SizedBox(height: 15),
          Text(
            "Albums Screen",
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 90,
            color: Colors.orange,
          ),
          SizedBox(height: 15),
          Text(
            "Profile Screen",
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
