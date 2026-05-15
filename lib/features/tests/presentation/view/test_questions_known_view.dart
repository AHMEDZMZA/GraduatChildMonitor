import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../bloc/test_cubit.dart';
import '../widgets/build_answer_option.dart';

class TestQuestionsKnownView extends StatefulWidget {
  final ChildEntity child;
  final String testType;

  const TestQuestionsKnownView({
    super.key,
    required this.child,
    required this.testType,
  });

  @override
  State<TestQuestionsKnownView> createState() => _TestQuestionsKnownViewState();
}

class _TestQuestionsKnownViewState extends State<TestQuestionsKnownView> {
  // FIX: store answers keyed by q_id (from the entity) not page index so the
  // submission map aligns with what the API expects
  final Map<int, String> answers = {};
  final PageController controller = PageController();
  int currentQuestionIndex = 0;
  // FIX: keep the full QuestionEntity list so we can access q_id per question
  List<QuestionEntity> questions = [];
  String instructions = '';
  bool isLoading = true;
  // FIX: guard flag to avoid double-pop or pop-when-closed crashes
  bool _isDialogShowing = false;

  static const Map<String, String> _typeToTitle = {
    'adhd': 'ADHD Test',
    'dyslexia': 'Learning Disabilities Test',
    'behavior': 'Behavior Modification Test',
    'autism': 'Autism Test',
    'down_syndrome': 'Down Syndrome Test',
  };

  @override
  void initState() {
    super.initState();
    context.read<TestCubit>().getQuestions(widget.testType);
  }

  int _calculateAge(String birthDate) {
    final birth = DateTime.parse(birthDate);
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  String _convertGender(String gender) {
    return gender.toLowerCase() == 'male' ? 'm' : 'f';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<TestCubit, TestState>(
          listener: (context, state) {
            if (state is QuestionsLoaded) {
              setState(() {
                questions = state.questionsResponse.questions;
                instructions = state.questionsResponse.instructions;
                isLoading = false;
              });
            } else if (state is QuestionsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SubmitTestLoading) {
              _isDialogShowing = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                const Center(child: CircularProgressIndicator()),
              );
            } else if (state is SubmitTestSuccess) {
              if (_isDialogShowing) {
                _isDialogShowing = false;
                Navigator.pop(context); // close loading dialog
              }
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.testComplete,
                arguments: state.result,
              );
            } else if (state is SubmitTestFailure) {
              if (_isDialogShowing) {
                _isDialogShowing = false;
                Navigator.pop(context); // close loading dialog
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is QuestionsLoading || isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (questions.isEmpty) {
              return const Center(child: Text('No questions available'));
            }

            final progress = (currentQuestionIndex + 1) / questions.length;
            // FIX: resolve the current question entity so we can use its q_id
            final currentQuestion = questions[currentQuestionIndex];

            return Padding(
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
                    _typeToTitle[widget.testType] ?? widget.testType.toUpperCase(),
                    style: AppTextStyles.nunito30w900Black,
                  ),
                  const Text(
                    AppStrings.testQuestionsKnownTitle,
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
                  const SizedBox(height: 30),
                  Expanded(
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
                        final question = questions[index];
                        final qId = question.qId;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // FIX: answer values changed from 'Yes/No/Maybe' →
                            // 'yes/no/sometimes' to match what the API expects.
                            // Keys now use qId instead of page index.
                            AnswerOption(
                              label: 'Yes',
                              selected: answers[qId] == 'yes',
                              onTap: () {
                                setState(() => answers[qId] = 'yes');
                              },
                            ),
                            const SizedBox(height: 15),
                            AnswerOption(
                              label: 'No',
                              selected: answers[qId] == 'no',
                              onTap: () {
                                setState(() => answers[qId] = 'no');
                              },
                            ),
                            const SizedBox(height: 15),
                            AnswerOption(
                              label: 'Sometimes',
                              selected: answers[qId] == 'sometimes',
                              onTap: () {
                                setState(() => answers[qId] = 'sometimes');
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
                          text: AppStrings.previousButton,
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
                            ? AppStrings.viewSubmitButton
                            : AppStrings.nextButton,
                        // FIX: check by q_id not page index
                        onTap: answers[currentQuestion.qId] == null
                            ? null
                            : () {
                          if (currentQuestionIndex <
                              questions.length - 1) {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            context.read<TestCubit>().submitTest(
                              childId: widget.child.id!,
                              testType: widget.testType,
                              age: _calculateAge(widget.child.birthDate),
                              sex: _convertGender(widget.child.gender),
                              jaundice: 'no',
                              familyAsd: 'no',
                              answers: answers,
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
          },
        ),
      ),
    );
  }
}