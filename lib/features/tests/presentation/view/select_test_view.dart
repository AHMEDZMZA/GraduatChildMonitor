import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../bottom_nav/presentation/views/app_bottom_nav_view.dart';
import '../../domain/entities/child_entity.dart';
import '../widgets/select_option_card.dart';

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
                AppStrings.selectTestTitle,
                style: AppTextStyles.nunito32w900Black,
              ),
              const SizedBox(height: 10),
              const Text(
                AppStrings.selectTestDescription,
                style: AppTextStyles.nunito14w400Grey,
              ),
              const SizedBox(height: 40),
              Center(
                child: SelectOptionCard(
                  index: 1,
                  selectedOption: selectedOption,
                  title: AppStrings.option1Title,
                  subtitle: AppStrings.option1Subtitle,
                  onTap: () => onOptionSelected(1),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SelectOptionCard(
                  index: 2,
                  selectedOption: selectedOption,
                  title: AppStrings.option2Title,
                  subtitle: AppStrings.option2Subtitle,
                  onTap: () => onOptionSelected(2),
                ),
              ),
              const SizedBox(height: 60),
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
                    // Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.unknownCondition,
                    //   arguments: widget.child,
                    // );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AppBottomNavBarView(),
                      ),
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