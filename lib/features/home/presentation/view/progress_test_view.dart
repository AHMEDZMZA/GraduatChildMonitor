import 'package:child_monitor_app/features/home/presentation/view/result_progress_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';

class ProgressTestView extends StatefulWidget {
  const ProgressTestView({super.key});

  @override
  State<ProgressTestView> createState() => _ProgressTestViewState();
}

class _ProgressTestViewState extends State<ProgressTestView> {
  final Map<int, String> answers = {};
  final PageController controller = PageController();
  int currentQuestionIndex = 0;

  final List<String> questions = [
    'Have you noticed an improvement in your child\'s\nability to focus and complete tasks?',
    'Has your child become more interactive with those around them?',
    'Has your child\'s visual or verbal communication improved?',
    'Has your child become better at responding to instructions?',
    'Have you noticed a general improvement in your child\'s daily behavior?',
  ];

  final String instructions =
      'Answer the following questions to help us better assess your child\'s condition.';

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
                'Track Your Child\'s Progress',
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
                        //   label: 'Much Better',
                        //   selected: answers[index] == 'Much Better',
                        //   onTap: () {
                        //     setState(() {
                        //       answers[index] = 'Much Better';
                        //     });
                        //   },
                        // ),
                        const SizedBox(height: 15),
                        // AnswerOption(
                        //   label: 'Same',
                        //   selected: answers[index] == 'Same',
                        //   onTap: () {
                        //     setState(() {
                        //       answers[index] = 'Same';
                        //     });
                        //   },
                        // ),
                        const SizedBox(height: 15),
                        // AnswerOption(
                        //   label: 'Worse',
                        //   selected: answers[index] == 'Worse',
                        //   onTap: () {
                        //     setState(() {
                        //       answers[index] = 'Worse';
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
                                        (context) => const ResultProgressView(),
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
