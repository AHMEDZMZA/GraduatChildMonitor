import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/child_entity.dart';
import '../widgets/select_option_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectTestView extends StatefulWidget {
  final ChildEntity child;

  const SelectTestView({super.key, required this.child});

  @override
  State<SelectTestView> createState() => _SelectTestViewState();
}

class _SelectTestViewState extends State<SelectTestView> {
  int? selectedOption = 1;

  void onOptionSelected(int value) {
    setState(() {
      selectedOption = value;
    });
  }

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
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                AppStrings.selectTestTitle,
                style: AppTextStyles.nunito32w900Black,
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.selectTestDescription,
                style: AppTextStyles.nunito14w400Grey,
              ),
              SizedBox(height: 40.h),
              Center(
                child: SelectOptionCard(
                  index: 1,
                  selectedOption: selectedOption,
                  title: AppStrings.option1Title,
                  subtitle: AppStrings.option1Subtitle,
                  onTap: () => onOptionSelected(1),
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: SelectOptionCard(
                  index: 2,
                  selectedOption: selectedOption,
                  title: AppStrings.option2Title,
                  subtitle: AppStrings.option2Subtitle,
                  onTap: () => onOptionSelected(2),
                ),
              ),
              SizedBox(height: 60.h),
              CustomButton(
                text: AppStrings.nextButton,
                onTap: () {
                  if (selectedOption == 2) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.knownCondition,
                      arguments: widget.child,
                    );
                  } else if (selectedOption == 1) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.unknownCondition,
                      arguments: widget.child,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}