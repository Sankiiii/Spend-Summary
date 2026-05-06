import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../providers/spend_providers.dart';
import '../theme/app_theme.dart';

class CategoryScroll extends ConsumerStatefulWidget {
  const CategoryScroll({super.key});

  @override
  ConsumerState<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends ConsumerState<CategoryScroll>
    with TickerProviderStateMixin {
  List<AnimationController> _itemCtrl = [];
  bool _didAnimate = false;

  void _startStagger(int count) {
    if (_didAnimate) return;
    _didAnimate = true;
    _itemCtrl = List.generate(
      count,
      (i) => AnimationController(
        vsync:    this,
        duration: Duration(milliseconds: 350 + i * 65),
      ),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      for (final c in _itemCtrl) {
        if (mounted) c.forward();
      }
    });
  }

  @override
  void dispose() {
    for (final c in _itemCtrl) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSummary   = ref.watch(spendSummaryProvider);
    final selectedIndex  = ref.watch(selectedCategoryIndexProvider);

    return asyncSummary.when(
      loading: () => const SizedBox.shrink(),
      error:   (_, __) => const SizedBox.shrink(),
      data:    (summary) {
        _startStagger(summary.categories.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: AppText.h2),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (selectedIndex != -1) {
                        ref
                            .read(selectedCategoryIndexProvider.notifier)
                            .state = -1;
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: selectedIndex != -1
                          ? Text('Clear filter',
                              key:   const ValueKey('clear'),
                              style: AppText.labelMd.copyWith(
                                  color: AppColors.danger, fontSize: 13.sp))
                          : Text('See all',
                              key:   const ValueKey('see'),
                              style: AppText.labelMd.copyWith(
                                  color: AppColors.accent, fontSize: 13.sp)),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            SizedBox(
              height: 155.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:         EdgeInsets.symmetric(horizontal: 20.w),
                itemCount:       summary.categories.length,
                itemBuilder:     (_, i) {
                  final cat        = summary.categories[i];
                  final isSelected = selectedIndex == i;

                  if (!_didAnimate || i >= _itemCtrl.length) {
                    return SizedBox(width: 112.w);
                  }

                  return AnimatedBuilder(
                    animation: _itemCtrl[i],
                    builder:   (_, __) {
                      final t = CurvedAnimation(
                        parent: _itemCtrl[i],
                        curve:  Curves.easeOutBack,
                      ).value.clamp(0.0, 1.05);

                      return Transform.scale(
                        scale: t,
                        child: Opacity(
                          opacity: _itemCtrl[i].value.clamp(0.0, 1.0),
                          child:   GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              ref
                                  .read(selectedCategoryIndexProvider.notifier)
                                  .state = isSelected ? -1 : i;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve:    Curves.easeOutCubic,
                              width:    112.w,
                              margin:   EdgeInsets.only(right: 10.w),
                              padding:  EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.r),
                                color: isSelected
                                    ? cat.color.withOpacity(0.15)
                                    : AppColors.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? cat.color.withOpacity(0.55)
                                      : AppColors.border,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color:       cat.color.withOpacity(0.18),
                                          blurRadius:  16.r,
                                          spreadRadius: -4.r,
                                          offset:      Offset(0, 6.h),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:  40.r,
                                    height: 40.r,
                                    decoration: BoxDecoration(
                                      color:        cat.color.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(11.r),
                                    ),
                                    child: Icon(cat.icon,
                                        color: cat.color, size: 20.sp),
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cat.name,
                                        style: AppText.labelMd
                                            .copyWith(fontSize: 11.sp),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '₹${NumberFormat('#,##,##0').format(cat.amount.toInt())}',
                                        style: AppText.monoMd.copyWith(
                                          fontSize: 12.sp,
                                          color: isSelected
                                              ? cat.color
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        '${cat.transactionCount} txns',
                                        style: AppText.bodySm
                                            .copyWith(fontSize: 9.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
