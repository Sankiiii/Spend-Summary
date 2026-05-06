import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_summary/providers/spend_providers.dart';
import 'package:spend_summary/theme/app_theme.dart';



class SpendSummaryScreen extends ConsumerStatefulWidget {
  const SpendSummaryScreen({super.key});

  @override
  ConsumerState<SpendSummaryScreen> createState() =>
      _SpendSummaryScreenState();
}

class _SpendSummaryScreenState extends ConsumerState<SpendSummaryScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showLabel = _scrollCtrl.offset < 80;
    if (showLabel != ref.read(showFabLabelProvider)) {
      ref.read(showFabLabelProvider.notifier).state = showLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:           AppColors.bg,
      extendBodyBehindAppBar:    true,
      appBar:                    _buildAppBar(),
      floatingActionButton:      _SpendFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          // Top purple glow splash
          Positioned(
            top:   0,
            left:  0,
            right: 0,
            child: Container(
              height: 320.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin:  Alignment.topCenter,
                  end:    Alignment.bottomCenter,
                  colors: [Color(0xFF110830), AppColors.bg],
                ),
              ),
            ),
          ),

          CustomScrollView(
            controller: _scrollCtrl,
            physics:    const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 110.h),         
                    const HeaderCard(),
                    SizedBox(height: 24.h),
                    const SpendDonut(),
                    SizedBox(height: 28.h),
                    const CategoryScroll(),
                    SizedBox(height: 28.h),
                    const TransactionList(),
                    SizedBox(height: 110.h),           
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left:   0,
            right:  0,
            height: 100.h,
            child:  IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: AppGradients.bottomFade),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(90.h),
      child: ClipRect(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg.withOpacity(0.85),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width:  40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            shape:    BoxShape.circle,
                            gradient: AppGradients.accentBtn,
                            boxShadow: [
                              BoxShadow(
                                color:       AppColors.accent.withOpacity(0.4),
                                blurRadius:  12.r,
                                spreadRadius: -4.r,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text('A',
                                style: AppText.h2.copyWith(
                                    color: Colors.white, fontSize: 17.sp)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            Text('Good morning',
                                style: AppText.bodySm
                                    .copyWith(fontSize: 11.sp)),
                            SizedBox(height: 1.h),
                            Text('Arjun Sharma',
                                style: AppText.h2.copyWith(fontSize: 16.sp)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      _AppBarIconBtn(
                        icon:  Icons.search_rounded,
                        onTap: () => _toast('Search coming soon'),
                      ),
                      SizedBox(width: 8.w),
                      _AppBarIconBtn(
                        icon:    Icons.notifications_outlined,
                        onTap:   () => _toast('No new notifications'),
                        hasBadge: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: AppText.bodyMd.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r)),
        margin:   EdgeInsets.all(16.r),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _AppBarIconBtn({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width:  38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 18.sp),
          ),
          if (hasBadge)
            Positioned(
              top:   6.h,
              right: 7.w,
              child: Container(
                width:  7.r,
                height: 7.r,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpendFAB extends ConsumerWidget {
  const _SpendFAB();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLabel = ref.watch(showFabLabelProvider);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet(
          context:           context,
          backgroundColor:   Colors.transparent,
          isScrollControlled: true,
          builder:           (_) => const AddExpenseSheet(),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve:    Curves.easeOutCubic,
        height:   52.h,
        padding:  EdgeInsets.symmetric(horizontal: showLabel ? 20.w : 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          gradient:     AppGradients.accentBtn,
          boxShadow: [
            BoxShadow(
              color:       AppColors.accent.withOpacity(0.4),
              blurRadius:  20.r,
              spreadRadius: -4.r,
              offset:      Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve:    Curves.easeOutCubic,
              child:    showLabel
                  ? Row(children: [
                      SizedBox(width: 8.w),
                      Text('Add Expense',
                          style: AppText.labelLg.copyWith(
                              color:    Colors.white,
                              fontSize: 14.sp)),
                    ])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
