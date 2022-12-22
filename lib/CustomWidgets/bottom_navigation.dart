import 'package:flutter/material.dart';
import 'package:ratemymusic/CustomWidgets/animated_bar.dart';

class BottomNavigation extends StatefulWidget {
  final List<BarItem> barItems = [
    BarItem(
      text: "Home",
      iconData: Icons.home,
      color: Colors.indigo,
    ),
    BarItem(
      text: "Search",
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "Profile",
      iconData: Icons.person_outline,
      color: Colors.teal,
    ),
  ];

  int selectedIndex = 0;
  BottomNavigation({super.key, required this.selectedIndex});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(fontSize: 20.0, iconSize: 30.0),
        onBarTap: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        });
  }
}
