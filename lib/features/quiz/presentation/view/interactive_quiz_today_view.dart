import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/info_card_quiz.dart';

class InteractiveQuizTodayView extends StatelessWidget {
  final String? childId;

  const InteractiveQuizTodayView({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    // Get childId from arguments if not provided
    final String? passedChildId =
        childId ?? ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
              ),

              const SizedBox(height: 60),

              CustomText(
                text: 'Interactive Quiz',
                style: AppTextStyles.nunito30w900Black.copyWith(fontSize: 28),
              ),

              const SizedBox(height: 10),

              const CustomText(
                text:
                    'A short quiz to help your child learn through fun and simple questions.',
                style: AppTextStyles.nunito14w400Grey,
              ),

              const SizedBox(height: 42),

              const Center(child: InfoCardQuiz()),

              const SizedBox(height: 80),

              CustomButton(
                text: 'Start Quiz',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.testQuiz,
                    arguments: passedChildId,
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
