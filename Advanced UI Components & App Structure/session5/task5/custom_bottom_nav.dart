5.Refactor your code to move the BottomNavigationBar into a separate widget file (e.g., custom_bottom_nav.dart) and import it into your main screen.
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,

      onTap: onItemTapped,

      backgroundColor: Colors.black,
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.grey,

      selectedFontSize: 14,
      unselectedFontSize: 12,

      type: BottomNavigationBarType.fixed,

      items: [
        BottomNavigationBarItem(
          icon: Icon(
            selectedIndex == 0
                ? Icons.music_note
                : Icons.music_note_outlined,
          ),
          label: "Songs",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            selectedIndex == 1
                ? Icons.album
                : Icons.album_outlined,
          ),
          label: "Albums",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            selectedIndex == 2
                ? Icons.person
                : Icons.person_outline,
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
