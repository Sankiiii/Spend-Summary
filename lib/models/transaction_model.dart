import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String merchant;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color color;
  final bool isCredit;

  const Transaction({
    required this.id,
    required this.merchant,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
    this.isCredit = false,
  });
}
