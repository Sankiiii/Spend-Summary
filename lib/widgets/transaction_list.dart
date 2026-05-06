import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:spend_summary/models/transaction_model.dart';

import '../providers/spend_providers.dart';
import '../theme/app_theme.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = ref.watch(groupedTransactionsProvider);
    final total   = ref.watch(filteredTransactionsProvider).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transactions', style: AppText.h2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color:        AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  '$total items',
                  style: AppText.monoSm.copyWith(
                      color: AppColors.accent, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 14.h),

        if (grouped.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.receipt_long_rounded,
                      color: AppColors.textMuted, size: 40.sp),
                  SizedBox(height: 12.h),
                  Text('No transactions found',
                      style: AppText.bodyMd),
                ],
              ),
            ),
          )
        else
          ...grouped.entries
              .map((e) => _DateGroup(date: e.key, transactions: e.value)),
      ],
    );
  }
}

class _DateGroup extends StatelessWidget {
  final String date;
  final List<Transaction> transactions;
  const _DateGroup({required this.date, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 7.h),
          child: Text(
            date.toUpperCase(),
            style: AppText.monoSm.copyWith(letterSpacing: 1.2),
          ),
        ),
        ...transactions.map((t) => _TransactionTile(txn: t)),
        SizedBox(height: 2.h),
      ],
    );
  }
}

class _TransactionTile extends StatefulWidget {
  final Transaction txn;
  const _TransactionTile({required this.txn});

  @override
  State<_TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<_TransactionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final txn = widget.txn;

    return GestureDetector(
      onTapDown:  (_) => setState(() => _pressed = true),
      onTapUp:    (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap:      () => _showDetail(context, txn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin:   EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
        padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color:        _pressed ? AppColors.surfaceHigh : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _pressed
                ? txn.color.withOpacity(0.4)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width:  44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color:        txn.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(txn.icon, color: txn.color, size: 20.sp),
            ),

            SizedBox(width: 13.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.merchant,
                    style:    AppText.labelLg.copyWith(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Container(
                        width:  6.r,
                        height: 6.r,
                        decoration: BoxDecoration(
                          color: txn.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(txn.category,
                          style: AppText.bodySm.copyWith(fontSize: 11.sp)),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            // Amount + time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  txn.isCredit
                      ? '+₹${NumberFormat('#,##,##0').format(txn.amount.toInt())}'
                      : '-₹${NumberFormat('#,##,##0').format(txn.amount.toInt())}',
                  style: AppText.monoMd.copyWith(
                    fontSize: 13.sp,
                    color: txn.isCredit
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  DateFormat('h:mm a').format(txn.date),
                  style: AppText.monoSm.copyWith(fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext ctx, Transaction txn) {
    showModalBottomSheet(
      context:           ctx,
      backgroundColor:   Colors.transparent,
      isScrollControlled: true,
      builder:           (_) => _DetailSheet(txn: txn),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  final Transaction txn;
  const _DetailSheet({required this.txn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 28.h),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(28.r),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:  36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color:        AppColors.border,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 22.h),

          Container(
            width:  64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color:        txn.color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(txn.icon, color: txn.color, size: 28.sp),
          ),

          SizedBox(height: 14.h),

          Text(txn.merchant,
              style: AppText.h1.copyWith(fontSize: 20.sp)),

          SizedBox(height: 4.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color:        txn.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(txn.category,
                style: AppText.labelMd.copyWith(
                    color: txn.color, fontSize: 12.sp)),
          ),

          SizedBox(height: 20.h),

          // Amount
          Text(
            txn.isCredit
                ? '+₹${NumberFormat('#,##,##0.##').format(txn.amount)}'
                : '-₹${NumberFormat('#,##,##0.##').format(txn.amount)}',
            style: AppText.displayMd.copyWith(
              color:    txn.isCredit ? AppColors.success : AppColors.textPrimary,
              fontSize: 34.sp,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            DateFormat('d MMMM yyyy, h:mm a').format(txn.date),
            style: AppText.monoSm.copyWith(fontSize: 12.sp),
          ),

          SizedBox(height: 24.h),

          Divider(color: AppColors.border, height: 1),
          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surfaceHigh,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r)),
              ),
              child: Text('Close',
                  style: AppText.labelLg.copyWith(fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
