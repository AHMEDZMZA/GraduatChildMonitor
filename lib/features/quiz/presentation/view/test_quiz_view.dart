import 'package:easy_localization/easy_localization.dart';
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
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestQuizView extends StatelessWidget {
  final String? childId;

  const TestQuizView({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    // Get childId from arguments if not provided as constructor parameter
    String? passedChildId =
        childId ?? ModalRoute.of(context)?.settings.arguments as String?;

    if (passedChildId == null) {
      try {
        final homeState = context.read<HomeCubit>().state;
        if (homeState is HomeSuccess) {
          passedChildId = homeState.homeData.selectedChildId ??
              (homeState.homeData.children.isNotEmpty
                  ? homeState.homeData.children.first.id
                  : null);
        }
      } catch (_) {}
    }

    return BlocProvider(
      create: (context) => getIt<QuizCubit>()..getQuizQuestions(),
      child: TestQuizContent(childId: passedChildId ?? "1"),
    );
  }
}

class TestQuizContent extends StatefulWidget {
  final String childId;

  const TestQuizContent({super.key, required this.childId});

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              String displayMessage = state.message;
              if (displayMessage.contains('Incorrect string value') || displayMessage.contains('500') || displayMessage.contains('execute statement')) {
                displayMessage = 'An error occurred while saving the quiz results on the server. Please try again later.';
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(displayMessage)));
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
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
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
                    SizedBox(height: 30.h),
                    Text(
                      state.data.title.isNotEmpty
                          ? state.data.title
                          : 'Interactive Quiz',
                      style: AppTextStyles.nunito30w900Black,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      state.data.description.isNotEmpty
                          ? state.data.description
                          : 'Choose the answer that best describes your child',
                      style: AppTextStyles.nunito14w400Grey,
                    ),
                    SizedBox(height: 30.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorManager.primaryBlue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Question: ${currentQuestionIndex + 1}/${questions.length}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 25.h),
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
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 30.h),
                              AnswerOption(
                                label: 'Yes',
                                selected: answers[q.id] == 'Yes',
                                onTap: () {
                                  setState(() {
                                    answers[q.id] = 'Yes';
                                  });
                                },
                              ),
                              SizedBox(height: 15.h),
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
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        if (currentQuestionIndex > 0)
                          CustomButtonSmallTest(
                            text: 'previous'.tr(),
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
                              ? 'submit'.tr()
                              : 'next'.tr(),
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
                                      widget.childId,
                                      formattedAnswers,
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
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

