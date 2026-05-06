import 'package:flutter/material.dart';

class SpendCategory {
  final String name;
  final IconData icon;
  final double amount;
  final Color color;
  final int transactionCount;

  const SpendCategory({
    required this.name,
    required this.icon,
    required this.amount,
    required this.color,
    required this.transactionCount,
  });
}
