import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spend_summary/models/spend_summary_model.dart';
import 'package:spend_summary/models/transaction_model.dart';

import '../data/spend_repository.dart';



final spendSummaryProvider = FutureProvider<SpendSummary>((ref) {
  return SpendRepository.fetchSummary();
});


final selectedCategoryIndexProvider = StateProvider<int>((ref) => -1);


final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final asyncSummary = ref.watch(spendSummaryProvider);
  final selectedIdx  = ref.watch(selectedCategoryIndexProvider);

  return asyncSummary.when(
    data: (summary) {
      if (selectedIdx == -1) return summary.transactions;
      final name = summary.categories[selectedIdx].name;
      return summary.transactions.where((t) => t.category == name).toList();
    },
    loading: () => [],
    error:   (_, __) => [],
  );
});


final groupedTransactionsProvider =
    Provider<LinkedHashMap<String, List<Transaction>>>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  final grouped = LinkedHashMap<String, List<Transaction>>();
  for (final txn in transactions) {
    final key = _dateLabel(txn.date);
    grouped.putIfAbsent(key, () => []).add(txn);
  }
  return grouped;
});

String _dateLabel(DateTime d) {
  const months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}


final showFabLabelProvider = StateProvider<bool>((ref) => true);


class AddExpenseState {
  final String amount;
  final String note;
  final String category;
  final bool isSubmitting;
  final bool submitted;

  const AddExpenseState({
    this.amount       = '',
    this.note         = '',
    this.category     = 'Food',
    this.isSubmitting = false,
    this.submitted    = false,
  });

  bool get isValid => amount.isNotEmpty && double.tryParse(amount) != null;

  AddExpenseState copyWith({
    String? amount,
    String? note,
    String? category,
    bool? isSubmitting,
    bool? submitted,
  }) =>
      AddExpenseState(
        amount:       amount       ?? this.amount,
        note:         note         ?? this.note,
        category:     category     ?? this.category,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        submitted:    submitted    ?? this.submitted,
      );
}

class AddExpenseNotifier extends StateNotifier<AddExpenseState> {
  AddExpenseNotifier() : super(const AddExpenseState());

  void setAmount(String v)   => state = state.copyWith(amount: v);
  void setNote(String v)     => state = state.copyWith(note: v);
  void setCategory(String v) => state = state.copyWith(category: v);

  Future<void> submit() async {
    if (!state.isValid) return;
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(milliseconds: 900));
    state = state.copyWith(isSubmitting: false, submitted: true);
  }

  void reset() => state = const AddExpenseState();
}

final addExpenseProvider =
    StateNotifierProvider.autoDispose<AddExpenseNotifier, AddExpenseState>(
  (ref) => AddExpenseNotifier(),
);
