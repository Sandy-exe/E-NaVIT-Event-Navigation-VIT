import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const NavBar({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GNav(
          color: Colors.grey[400],
          activeColor: Colors.grey.shade700,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Colors.grey.shade100,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 16,
          onTabChange: (value) => onTabChange!(value),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.edit,
              text: 'Approval',
            ),
            GButton(
              icon: Icons.group,
              text: 'My Club',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ]),
    );
  }
}
