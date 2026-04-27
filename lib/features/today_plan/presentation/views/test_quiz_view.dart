import 'package:child_monitor_app/features/today_plan/presentation/views/result_quiz_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';

class TestQuizView extends StatefulWidget {
  const TestQuizView({super.key});

  @override
  State<TestQuizView> createState() => _TestQuizState();
}

class _TestQuizState extends State<TestQuizView> {
  final Map<int, String> answers = {};
  final PageController controller = PageController();
  int currentQuestionIndex = 0;

  final List<String> questions = [
    'Does your child find it difficult to stay\n focused on one task?',
    'Does your child find it difficult to stay\n focused on one task?',
    'Does your child find it difficult to stay\n focused on one task?'
  ];

  final String instructions =
      'Choose the answer that best describes your child';

  @override
  Widget build(BuildContext context) {
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (currentQuestionIndex > 0) {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
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

              const SizedBox(height: 30),

              const Text(
                'Interactive Quiz',
                style: AppTextStyles.nunito30w900Black,
              ),

              const SizedBox(height: 5),

              Text(instructions, style: AppTextStyles.nunito14w400Grey),

              const SizedBox(height: 30),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorManager.primaryBlue,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Question: ${currentQuestionIndex + 1}/${questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryBlue,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 305,
                child: PageView.builder(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentQuestionIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questions[index],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // AnswerOption(
                        //   label: 'Yes',
                        //   selected: answers[index] == 'Yes',
                        //   onTap: () {
                        //     setState(() {
                        //       answers[index] = 'Yes';
                        //     });
                        //   },
                        // ),
                        // const SizedBox(height: 15),
                        // AnswerOption(
                        //   label: 'No',
                        //   selected: answers[index] == 'No',
                        //   onTap: () {
                        //     setState(() {
                        //       answers[index] = 'No';
                        //     });
                        //   },
                        // ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  if (currentQuestionIndex > 0)
                    CustomButtonSmallTest(
                      text: 'Previous',
                      onTap: () {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),

                  const Spacer(),

                  CustomButtonSmallTest(
                    text:
                    currentQuestionIndex == questions.length - 1
                        ? 'Submit'
                        : 'Next',
                    onTap:
                    answers[currentQuestionIndex] == null
                        ? null
                        : () {
                      if (currentQuestionIndex < questions.length - 1) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const ResultQuizView(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
