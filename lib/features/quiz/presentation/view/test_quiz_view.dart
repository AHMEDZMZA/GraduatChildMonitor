import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import 'package:child_monitor_app/features/tests/presentation/widgets/build_answer_option.dart';
import 'package:child_monitor_app/features/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:child_monitor_app/features/quiz/presentation/cubit/quiz_state.dart';
import 'package:child_monitor_app/core/di/service_locator.dart';

class TestQuizView extends StatelessWidget {
  const TestQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<QuizCubit>()..getQuizQuestions(),
      child: const TestQuizContent(),
    );
  }
}

class TestQuizContent extends StatefulWidget {
  const TestQuizContent({super.key});

  @override
  State<TestQuizContent> createState() => _TestQuizContentState();
}

class _TestQuizContentState extends State<TestQuizContent> {
  final Map<int, String> answers = {};
  final PageController controller = PageController();
  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: BlocConsumer<QuizCubit, QuizState>(
          listener: (context, state) {
            if (state is QuizSubmitSuccess) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.resultQuiz,
                arguments: state.result,
              );
            } else if (state is QuizError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is QuizLoading || state is QuizInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is QuizQuestionsLoaded) {
              final questions = state.data.questions;
              final progress = (currentQuestionIndex + 1) / questions.length;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
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
                    Text(
                      state.data.title.isNotEmpty
                          ? state.data.title
                          : 'Interactive Quiz',
                      style: AppTextStyles.nunito30w900Black,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      state.data.description.isNotEmpty
                          ? state.data.description
                          : 'Choose the answer that best describes your child',
                      style: AppTextStyles.nunito14w400Grey,
                    ),
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
                          final q = questions[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.question,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 30),
                              AnswerOption(
                                label: 'Yes',
                                selected: answers[q.id] == 'Yes',
                                onTap: () {
                                  setState(() {
                                    answers[q.id] = 'Yes';
                                  });
                                },
                              ),
                              const SizedBox(height: 15),
                              AnswerOption(
                                label: 'No',
                                selected: answers[q.id] == 'No',
                                onTap: () {
                                  setState(() {
                                    answers[q.id] = 'No';
                                  });
                                },
                              ),
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
                          text: currentQuestionIndex == questions.length - 1
                              ? 'Submit'
                              : 'Next',
                          onTap:
                              answers[questions[currentQuestionIndex].id] ==
                                  null
                              ? null
                              : () {
                                  if (currentQuestionIndex <
                                      questions.length - 1) {
                                    controller.nextPage(
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    final Map<String, dynamic>
                                    formattedAnswers = {};
                                    final keyMap = {
                                      1: "q1_focus",
                                      2: "q2_follow_instructions",
                                      3: "q3_complete_tasks",
                                    };

                                    answers.forEach((qId, answer) {
                                      String key = keyMap[qId] ?? 'q$qId';
                                      formattedAnswers[key] = answer == 'Yes';
                                    });
                                    context.read<QuizCubit>().submitQuiz(
                                      "5",
                                      formattedAnswers,
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
