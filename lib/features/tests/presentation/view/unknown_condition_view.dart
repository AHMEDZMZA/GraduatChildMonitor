import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/child_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnknownConditionView extends StatefulWidget {
  final ChildEntity child;

  const UnknownConditionView({super.key, required this.child});

  @override
  State<UnknownConditionView> createState() => _UnknownConditionViewState();
}

class _UnknownConditionViewState extends State<UnknownConditionView> {
  final Set<String> selectedConditions = {};

  final Map<String, String> conditions = {
    'ADHD': 'adhd',
    'Learning Difficulties': 'dyslexia',
    'Behavior Modification': 'behavior',
    'Autism': 'autism',
    'Down Syndrome': 'down_syndrome',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: ColorManager.buttonBlue,
                  radius: 20,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: ColorManager.darkText,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                AppStrings.unknownConditionTitle,
                style: AppTextStyles.nunito30w900Black,
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.unknownConditionDescription,
                style: AppTextStyles.nunito14w400Grey,
              ),
              SizedBox(height: 40.h),
              Expanded(
                child: ListView.builder(
                  itemCount: conditions.length,
                  itemBuilder: (context, index) {
                    final condition = conditions.keys.elementAt(index);
                    final isAvailable = condition == 'ADHD' ||
                        condition == 'Learning Difficulties' ||
                        condition == 'Autism';
                    final isSelected = selectedConditions.contains(condition);

                    return GestureDetector(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                if (isSelected) {
                                  selectedConditions.remove(condition);
                                } else {
                                  selectedConditions.add(condition);
                                }
                              });
                            }
                          : null,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 12.w,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? (isSelected
                                  ? ColorManager.babyBlue
                                  : ColorManager.white)
                              : Colors.grey.shade100,
                          border: Border.all(
                            color: isAvailable && isSelected
                                ? ColorManager.primaryBlue
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: isAvailable
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: isAvailable
                                  ? (isSelected
                                      ? Colors.black
                                      : Colors.grey.shade500)
                                  : Colors.grey.shade400,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                condition,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: isAvailable
                                      ? (isSelected
                                          ? ColorManager.primaryBlue
                                          : Colors.black87)
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (!isAvailable)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Coming soon',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomButton(
                text: AppStrings.nextButton,
                onTap: selectedConditions.isEmpty
                    ? null
                    : () {
                        // FIX: was passing only `widget.child` — the selected
                        // conditions were collected but completely ignored.
                        // Now we resolve the selected display names to their
                        // API type strings and pass both child + types so
                        // TestQuestionsUnknownView only loads the chosen tests.
                        final selectedTypes = selectedConditions
                            .map((name) => conditions[name]!)
                            .toList();

                        Navigator.pushNamed(
                          context,
                          AppRoutes.testQuestionsUnknown,
                          arguments: {
                            'child': widget.child,
                            'selectedTypes': selectedTypes,
                          },
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
