

import 'package:spend_summary/models/category_model.dart';
import 'package:spend_summary/models/transaction_model.dart';

class SpendSummary {
  final double totalSpend;
  final double lastMonthSpend;
  final List<SpendCategory> categories;
  final List<Transaction> transactions;

  const SpendSummary({
    required this.totalSpend,
    required this.lastMonthSpend,
    required this.categories,
    required this.transactions,
  });

  double get percentChange =>
      ((totalSpend - lastMonthSpend) / lastMonthSpend) * 100;

  bool get isSpendUp => percentChange > 0;

  int get totalTransactions => transactions.length;

  double get avgPerDay => totalSpend / 31;

  double get budgetUsedPercent => (totalSpend / 100000) * 100;
}
