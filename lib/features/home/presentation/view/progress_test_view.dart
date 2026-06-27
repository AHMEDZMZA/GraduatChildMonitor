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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:child_monitor_app/core/managers/local_notification_service.dart';
import 'package:easy_localization/easy_localization.dart';

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
            LocalNotificationService().showInstantNotification(
              id: 3,
              title: 'monthly_assessment_completed_title',
              body: 'monthly_assessment_completed_body'.tr(args: [widget.child.name]),
              type: 'assessment_completed',
            );
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.resultProgress,
              arguments: {
                'response': state.response,
                'child': widget.child,
              },
            );
          } else if (state is MonthlyAssessmentSubmitError) {
            String displayMessage = state.message;
            if (displayMessage.contains('Incorrect string value') || displayMessage.contains('500') || displayMessage.contains('execute statement')) {
              displayMessage = 'assessment_save_error'.tr();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  displayMessage,
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
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        state.message,
                        style: AppTextStyles.nunito14w400Grey,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        text: 'retry'.tr(),
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
          String assessmentTitle = 'track_progress_title'.tr();

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
            return Scaffold(
              body: Center(
                child: Text('no_questions'.tr()),
              ),
            );
          }

          final progress = (currentQuestionIndex + 1) / serverQuestions.length;
          final isSubmitting = state is MonthlyAssessmentSubmitLoading;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                      assessmentTitle,
                      style: AppTextStyles.nunito30w900Black,
                    ),

                    SizedBox(height: 5.h),

                    Text('assessment_instructions'.tr(), style: AppTextStyles.nunito14w400Grey),

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
                      '${'question'.tr()}${currentQuestionIndex + 1}/${serverQuestions.length}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryBlue,
                      ),
                    ),

                    SizedBox(height: 25.h),

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
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                ...question.options.map((option) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 15.h),
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

                    SizedBox(height: 20.h),

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
                                text: currentQuestionIndex == serverQuestions.length - 1
                                    ? 'submit'.tr()
                                    : 'next'.tr(),
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

                    SizedBox(height: 20.h),
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
