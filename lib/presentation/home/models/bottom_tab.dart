import 'package:flutter/material.dart';

enum BottomTab {
  gifts(title: "Подарки", icon: Icons.card_giftcard),
  people(title: "Люди", icon: Icons.people),
  settings(title: "Люди", icon: Icons.settings),;

  const BottomTab({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
