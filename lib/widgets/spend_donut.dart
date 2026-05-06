import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../providers/spend_providers.dart';
import '../theme/app_theme.dart';

class SpendDonut extends ConsumerStatefulWidget {
  const SpendDonut({super.key});

  @override
  ConsumerState<SpendDonut> createState() => _SpendDonutState();
}

class _SpendDonutState extends ConsumerState<SpendDonut>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _progress = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSummary = ref.watch(spendSummaryProvider);

    return asyncSummary.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spend Breakdown', style: AppText.h2),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    'May 2025',
                    style: AppText.monoSm.copyWith(
                      color: AppColors.accent,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130.r,
                  height: 130.r,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _progress,
                        builder: (_, __) => CustomPaint(
                          size: Size(130.r, 130.r),
                          painter: _DonutPainter(
                            categories: summary.categories,
                            total: summary.totalSpend,
                            progress: _progress.value,
                          ),
                        ),
                      ),

                      /// ✅ CENTER TEXT (SAFE)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '₹${NumberFormat('#,##,##0').format((summary.totalSpend / 1000).truncate())}K',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              fontFamily: 'JetBrainsMono',
                            ),
                          ),
                          Text(
                            'total',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textMuted,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 20.w),

                /// CATEGORY LIST
                Expanded(
                  child: Column(
                    children: summary.categories.take(6).map((cat) {
                      final pct = cat.amount / summary.totalSpend * 100;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 9.h),
                        child: Row(
                          children: [
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: cat.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                cat.name,
                                style: AppText.bodyMd
                                    .copyWith(fontSize: 12.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${pct.toStringAsFixed(0)}%',
                              style: AppText.monoSm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 🎨 DONUT PAINTER (NO TEXT HERE)
class _DonutPainter extends CustomPainter {
  final List categories;
  final double total;
  final double progress;

  const _DonutPainter({
    required this.categories,
    required this.total,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = size.shortestSide * 0.13;
    final radius = (size.shortestSide / 2) - strokeWidth / 2 - 2;
    final totalSweep = 2 * math.pi * progress;
    const gap = 0.04;
    double startAngle = -math.pi / 2;

    /// background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    /// segments
    for (final cat in categories) {
      final fraction = (cat.amount as double) / total;
      final sweep = fraction * totalSweep - gap;

      if (sweep <= 0) {
        startAngle += fraction * totalSweep;
        continue;
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        Paint()
          ..color = (cat.color as Color)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );

      startAngle += fraction * totalSweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress || old.total != total;
}