import 'package:child_monitor_app/features/tests/presentation/widgets/build_answer_option.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../../core/network/api_client.dart';
import '../cubit/monthly_assessment_cubit.dart';
import '../cubit/monthly_assessment_state.dart';

class ProgressTestView extends StatefulWidget {
  final ChildProfileEntity child;

  const ProgressTestView({super.key, required this.child});

  @override
  State<ProgressTestView> createState() => _ProgressTestViewState();
}

class _ProgressTestViewState extends State<ProgressTestView> {
  final Map<int, int> answers = {};
  final PageController controller = PageController();
  int currentQuestionIndex = 0;

  final String instructions =
      'Answer the following questions to help us better assess your child\'s condition.';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MonthlyAssessmentCubit>()
        ..getQuestions(widget.child.diagnosedCondition ?? 'ADHD'),
      child: BlocConsumer<MonthlyAssessmentCubit, MonthlyAssessmentState>(
        listener: (context, state) {
          if (state is MonthlyAssessmentSubmitSuccess) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.resultProgress,
              arguments: {
                'response': state.response,
                'child': widget.child,
              },
            );
          } else if (state is MonthlyAssessmentSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: 'Nunito'),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MonthlyAssessmentQuestionsLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryBlue,
                ),
              ),
            );
          }

          if (state is MonthlyAssessmentQuestionsError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: AppTextStyles.nunito14w400Grey,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Retry',
                        onTap: () {
                          context.read<MonthlyAssessmentCubit>().getQuestions(
                                widget.child.diagnosedCondition ?? 'ADHD',
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          List<MonthlyAssessmentQuestion> serverQuestions = [];
          String assessmentTitle = 'Track Your Child\'s Progress';

          if (state is MonthlyAssessmentQuestionsLoaded) {
            serverQuestions = state.response.questions.questions;
            assessmentTitle = state.response.questions.title;
          } else {
            final cubitState = context.read<MonthlyAssessmentCubit>().state;
            if (cubitState is MonthlyAssessmentQuestionsLoaded) {
              serverQuestions = cubitState.response.questions.questions;
              assessmentTitle = cubitState.response.questions.title;
            }
          }

          if (serverQuestions.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text('No questions available.'),
              ),
            );
          }

          final progress = (currentQuestionIndex + 1) / serverQuestions.length;
          final isSubmitting = state is MonthlyAssessmentSubmitLoading;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

                    Text(
                      assessmentTitle,
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
                      'Question: ${currentQuestionIndex + 1}/${serverQuestions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Expanded(
                      child: PageView.builder(
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: serverQuestions.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentQuestionIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final question = serverQuestions[index];
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.text,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ...question.options.map((option) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: AnswerOption(
                                      label: option.text,
                                      selected: answers[index] == option.value,
                                      onTap: () {
                                        setState(() {
                                          answers[index] = option.value;
                                        });
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    isSubmitting
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.primaryBlue,
                            ),
                          )
                        : Row(
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
                                text: currentQuestionIndex == serverQuestions.length - 1
                                    ? 'Submit'
                                    : 'Next',
                                onTap: answers[currentQuestionIndex] == null
                                    ? null
                                    : () {
                                        if (currentQuestionIndex < serverQuestions.length - 1) {
                                          controller.nextPage(
                                            duration: const Duration(milliseconds: 350),
                                            curve: Curves.easeInOut,
                                          );
                                        } else {
                                          final List<MonthlyAssessmentAnswer> submissionAnswers = [];
                                          for (int i = 0; i < serverQuestions.length; i++) {
                                            final q = serverQuestions[i];
                                            submissionAnswers.add(
                                              MonthlyAssessmentAnswer(
                                                qId: q.id,
                                                value: answers[i] ?? 0,
                                              ),
                                            );
                                          }
                                          context.read<MonthlyAssessmentCubit>().submitAssessment(
                                            childId: int.tryParse(widget.child.id) ?? 0,
                                            disorder: widget.child.diagnosedCondition ?? 'ADHD',
                                            answers: submissionAnswers,
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
        },
      ),
    );
  }
}
