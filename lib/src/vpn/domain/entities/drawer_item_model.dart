import 'package:flutter/material.dart';

class DrawerItem {
  DrawerItem({
    required this.title,
    required this.icon,
    this.iconColor = Colors.white,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
}
