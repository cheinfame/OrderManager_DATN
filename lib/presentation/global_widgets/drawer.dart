import 'package:flutter/material.dart';

Widget buildDrawer(int selectedIndex, Function(int) onTap) {
  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    child: Container(
      color: Colors.black87,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildMenuItem(0, 'Dashboard', Icons.dashboard, selectedIndex, () => onTap(0)),
          _buildMenuItem(1, 'Orders', Icons.shopping_bag, selectedIndex, () => onTap(1)),
          _buildMenuItem(2, 'Users', Icons.person, selectedIndex, () => onTap(2)),
        ],
      ),
    ),
  );
}

Widget _buildMenuItem(int itemIndex, String title, IconData iconData,
    int selectedIndex, VoidCallback onTap) {
  final bool isSelected = itemIndex == selectedIndex;
  return ListTile(
    tileColor: isSelected ? Colors.black : Colors.black54,
    leading: Icon(
      iconData,
      color: isSelected ? Colors.white : Colors.white38,
    ),
    title: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white38,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
    onTap: onTap,
  );
}
