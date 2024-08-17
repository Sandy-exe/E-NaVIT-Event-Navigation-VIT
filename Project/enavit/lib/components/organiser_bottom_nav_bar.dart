import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final int userRole;
  const NavBar({super.key, this.onTabChange, required this.userRole});

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
          tabs: [
            const GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            userRole != 4
                ? const GButton(
                    icon: Icons.edit,
                    text: 'Approval',
                  )
                : const GButton(
                    icon: Icons.edit,
                    text: 'Approve',
                  ),
            const GButton(
              icon: Icons.group,
              text: 'My Club',
            ),
            const GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ]),
    );
  }
}
