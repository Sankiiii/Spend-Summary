import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/spend_providers.dart';
import '../theme/app_theme.dart';

const _formCategories = [
  'Food', 'Travel', 'Shopping', 'Bills',
  'Health', 'Entertainment', 'Transport', 'Other',
];

class AddExpenseSheet extends ConsumerStatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(addExpenseProvider);
    final notifier  = ref.read(addExpenseProvider.notifier);

    ref.listen<AddExpenseState>(addExpenseProvider, (prev, next) {
      if (!prev!.submitted && next.submitted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense added!',
                style: AppText.bodyMd.copyWith(color: AppColors.textPrimary)),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            margin: EdgeInsets.all(16.r),
          ),
        );
      }
    });

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin:  EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(28.r),
          border:       Border.all(color: AppColors.border),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width:  36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color:        AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Expense', style: AppText.h1),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width:  32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color:        AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.close_rounded,
                          color: AppColors.textSecondary, size: 16.sp),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _SectionLabel(label: 'Amount'),
              SizedBox(height: 8.h),
              TextFormField(
                controller:   _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style:        AppText.bodyLg.copyWith(fontSize: 15.sp),
                onChanged:    notifier.setAmount,
                validator:    (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter an amount';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
                decoration: _inputDecoration(
                  hint:       '0.00',
                  prefix:     Text('₹ ',
                      style: AppText.bodyLg.copyWith(
                          color: AppColors.textSecondary, fontSize: 15.sp)),
                ),
              ),

              SizedBox(height: 16.h),

              _SectionLabel(label: 'Note (optional)'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _noteCtrl,
                style:      AppText.bodyLg.copyWith(fontSize: 15.sp),
                onChanged:  notifier.setNote,
                decoration: _inputDecoration(hint: 'What was this for?'),
              ),

              SizedBox(height: 16.h),

              _SectionLabel(label: 'Category'),
              SizedBox(height: 10.h),
              Wrap(
                spacing:    8.w,
                runSpacing: 8.h,
                children:   _formCategories.map((cat) {
                  final selected = formState.category == cat;
                  return GestureDetector(
                    onTap: () => notifier.setCategory(cat),
                    child: AnimatedContainer(
                      duration:  const Duration(milliseconds: 180),
                      padding:   EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accent.withOpacity(0.18)
                            : AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                          color: selected
                              ? AppColors.accent.withOpacity(0.6)
                              : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: AppText.labelMd.copyWith(
                          color: selected
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 24.h),

              SizedBox(
                width:  double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: formState.isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await notifier.submit();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor:     Colors.transparent,
                    padding:         EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient:     AppGradients.accentBtn,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color:       AppColors.accent.withOpacity(0.35),
                          blurRadius:  16.r,
                          offset:      Offset(0, 6.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: formState.isSubmitting
                          ? SizedBox(
                              width:  20.r,
                              height: 20.r,
                              child: CircularProgressIndicator(
                                color:       Colors.white,
                                strokeWidth: 2.r,
                              ),
                            )
                          : Text('Save Expense',
                              style: AppText.labelLg.copyWith(
                                  color: Colors.white, fontSize: 15.sp)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefix,
  }) =>
      InputDecoration(
        hintText:  hint,
        hintStyle: AppText.bodyMd.copyWith(fontSize: 14.sp),
        prefixIcon: prefix != null
            ? Padding(
                padding: EdgeInsets.only(left: 16.w, top: 14.h),
                child:   prefix)
            : null,
        filled:      true,
        fillColor:   AppColors.surfaceHigh,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:
              BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:
              BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:
              BorderSide(color: AppColors.danger, width: 1.5),
        ),
        errorStyle: AppText.bodySm
            .copyWith(color: AppColors.danger, fontSize: 11.sp),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: AppText.labelMd.copyWith(fontSize: 12.sp),
      );
}
