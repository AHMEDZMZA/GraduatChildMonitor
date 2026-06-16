import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/child_entity.dart';

class KnownConditionView extends StatefulWidget {
  final ChildEntity child;

  const KnownConditionView({super.key, required this.child});

  @override
  State<KnownConditionView> createState() => _KnownConditionViewState();
}

class _KnownConditionViewState extends State<KnownConditionView> {
  String? selectedCondition;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                AppStrings.title,
                style: AppTextStyles.nunito30w900Black,
              ),
              const SizedBox(height: 10),
              const Text(
                AppStrings.description,
                style: AppTextStyles.nunito14w400Grey,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: conditions.length,
                  itemBuilder: (context, index) {
                    final condition = conditions.keys.elementAt(index);
                    final isSelected = selectedCondition == condition;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedCondition = null;
                          } else {
                            selectedCondition = condition;
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.babyBlue
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? ColorManager.primaryBlue
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade500,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              condition,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? ColorManager.primaryBlue
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
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
                onTap: selectedCondition == null
                    ? null
                    : () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.testQuestionsKnown,
                    arguments: {
                      'child': widget.child,
                      'testType': conditions[selectedCondition],
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