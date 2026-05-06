import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:spend_summary/models/spend_summary_model.dart';

import '../providers/spend_providers.dart';
import '../theme/app_theme.dart';

class HeaderCard extends ConsumerStatefulWidget {
  const HeaderCard({super.key});

  @override
  ConsumerState<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends ConsumerState<HeaderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _countUp;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1100),
    );
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve:  const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _ctrl,
      curve:  const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));
    _countUp = CurvedAnimation(
      parent: _ctrl,
      curve:  const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
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
      loading: () => _Skeleton(),
      error:   (e, _) => _ErrorCard(message: e.toString()),
      data:    (summary) => FadeTransition(
        opacity: _fade,
        child:   SlideTransition(
          position: _slide,
          child:    _CardContent(summary: summary, countUpAnim: _countUp),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final SpendSummary summary;
  final Animation<double> countUpAnim;

  const _CardContent({required this.summary, required this.countUpAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:     EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient:     AppGradients.header,
        boxShadow: [
          BoxShadow(
            color:      AppColors.accent.withOpacity(0.25),
            blurRadius:  40.r,
            spreadRadius: -8.r,
            offset:      Offset(0, 20.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(children: [
          _buildGlowOrb(top: -50.h, right: -30.w, size: 180.r, color: AppColors.accent.withOpacity(0.07)),
          _buildGlowOrb(bottom: -40.h, left: -20.w, size: 140.r, color: const Color(0xFF4ECDC4).withOpacity(0.05)),
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopRow(summary: summary),
                SizedBox(height: 16.h),
                _AmountDisplay(summary: summary, animation: countUpAnim),
                SizedBox(height: 8.h),
                _BudgetBar(percent: summary.budgetUsedPercent),
                SizedBox(height: 18.h),
                Divider(color: Colors.white.withOpacity(0.07), height: 1),
                SizedBox(height: 16.h),
                _MiniStatsRow(summary: summary),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildGlowOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) =>
      Positioned(
        top:    top,
        bottom: bottom,
        left:   left,
        right:  right,
        child:  Container(
          width:  size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      );
}

class _TopRow extends StatelessWidget {
  final SpendSummary summary;
  const _TopRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MAY 2025', style: AppText.monoSm.copyWith(letterSpacing: 2.0)),
              SizedBox(height: 3.h),
              Text('Total Spend', style: AppText.h2),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _ChangeBadge(isUp: summary.isSpendUp, pct: summary.percentChange),
      ],
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final bool isUp;
  final double pct;
  const _ChangeBadge({required this.isUp, required this.pct});

  @override
  Widget build(BuildContext context) {
    final color = isUp ? AppColors.danger : AppColors.success;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(50.r),
        border:       Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: color,
            size:  13.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            '${pct.abs().toStringAsFixed(1)}%',
            style: AppText.monoSm.copyWith(
              color:      color,
              fontWeight: FontWeight.w700,
              fontSize:   11.sp,
            ),
          ),
          SizedBox(width: 4.w),
          Text('vs last',
              style: AppText.bodySm.copyWith(
                color:    color.withOpacity(0.75),
                fontSize: 10.sp,
              )),
        ],
      ),
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  final SpendSummary summary;
  final Animation<double> animation;
  const _AmountDisplay({required this.summary, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder:   (_, __) {
        final shown = summary.totalSpend * animation.value;
        return Text(
          '₹${NumberFormat('#,##,##0').format(shown.toInt())}',
          style: AppText.displayLg,
        );
      },
    );
  }
}

class _BudgetBar extends StatefulWidget {
  final double percent;
  const _BudgetBar({required this.percent});

  @override
  State<_BudgetBar> createState() => _BudgetBarState();
}

class _BudgetBarState extends State<_BudgetBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1200),
    );
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 400), () {
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
    final clamped = (widget.percent / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Monthly Budget',
                style: AppText.bodySm.copyWith(color: AppColors.textMuted)),
            AnimatedBuilder(
              animation: _progress,
              builder:   (_, __) => Text(
                '${(widget.percent * _progress.value).toStringAsFixed(0)}% used',
                style: AppText.monoSm.copyWith(
                  color: widget.percent > 80
                      ? AppColors.danger
                      : AppColors.success,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        LayoutBuilder(
          builder: (_, constraints) => Stack(
            children: [
              Container(
                height:       5.h,
                width:        constraints.maxWidth,
                decoration:   BoxDecoration(
                  color:        AppColors.border,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              AnimatedBuilder(
                animation: _progress,
                builder:   (_, __) => Container(
                  height:     5.h,
                  width:      constraints.maxWidth * clamped * _progress.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.percent > 80
                          ? [AppColors.danger, AppColors.warning]
                          : [AppColors.accent, AppColors.accentSoft],
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                    boxShadow: [
                      BoxShadow(
                        color:      AppColors.accent.withOpacity(0.4),
                        blurRadius: 6.r,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStatsRow extends StatelessWidget {
  final SpendSummary summary;
  const _MiniStatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniStat(label: 'Transactions', value: '${summary.totalTransactions}'),
        _Vdivider(),
        _MiniStat(
            label: 'Avg / Day',
            value: '₹${NumberFormat('#,##,##0').format(summary.avgPerDay.toInt())}'),
        _Vdivider(),
        _MiniStat(
            label: 'Last Month',
            value: '₹${NumberFormat('#,##,##0').format(summary.lastMonthSpend.toInt())}'),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.bodySm),
            SizedBox(height: 3.h),
            Text(value, style: AppText.monoMd),
          ],
        ),
      );
}

class _Vdivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width:  1,
        height: 28.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        color:  Colors.white.withOpacity(0.08),
      );
}

// ─── Skeleton loader ──────────────────────────────────────────────────────────
class _Skeleton extends StatefulWidget {
  @override
  State<_Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<_Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin:  EdgeInsets.symmetric(horizontal: 20.w),
        height:  200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: Color.lerp(
            AppColors.surface,
            AppColors.surfaceHigh,
            _anim.value,
          ),
        ),
        child: Center(
          child: SizedBox(
            width:  24.r,
            height: 24.r,
            child:  CircularProgressIndicator(
              color:       AppColors.accent,
              strokeWidth: 2.5.r,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Error card ───────────────────────────────────────────────────────────────
class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        margin:  EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color:        AppColors.surface,
          border:
              Border.all(color: AppColors.danger.withOpacity(0.4), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded,
                color: AppColors.danger, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text('Failed to load: $message',
                  style: AppText.bodyMd
                      .copyWith(color: AppColors.danger)),
            ),
          ],
        ),
      );
}
