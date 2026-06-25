import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../bloc/test_cubit.dart';
import '../widgets/build_answer_option.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestQuestionsUnknownView extends StatefulWidget {
  final ChildEntity child;
  // FIX: accept only the test types the user actually selected instead of
  // always hard-coding all 5 tests
  final List<String> selectedTypes;

  const TestQuestionsUnknownView({
    super.key,
    required this.child,
    required this.selectedTypes,
  });

  @override
  State<TestQuestionsUnknownView> createState() =>
      _TestQuestionsUnknownViewState();
}

class _TestQuestionsUnknownViewState extends State<TestQuestionsUnknownView> {
  final PageController pageController = PageController();
  int currentQuestionIndex = 0;
  int currentTestIndex = 0;

  // FIX: key answers by '{testIndex}_{qId}' so submissions use real q_ids
  final Map<String, String> answers = {};

  // FIX: built from selectedTypes at runtime, not a static list of all 5
  late final List<Map<String, dynamic>> tests;

  // FIX: store full QuestionEntity lists to access q_id per question
  Map<String, List<QuestionEntity>> allQuestions = {};
  Map<String, String> allInstructions = {};
  bool isLoading = true;
  int loadedTests = 0;
  // FIX: guard against double-pop on dialog
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
    // Build the test list from only the types the user selected
    tests = widget.selectedTypes
        .map((type) => {
      'title': _typeToTitle[type] ?? type,
      'type': type,
    })
        .toList();
    _loadAllTests();
  }

  void _loadAllTests() {
    for (var test in tests) {
      context.read<TestCubit>().getQuestions(test['type'] as String);
    }
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
                final testType = state.questionsResponse.testType;
                // Only count tests that were actually requested
                if (tests.any((t) => t['type'] == testType)) {
                  allQuestions[testType] =
                      state.questionsResponse.questions;
                  allInstructions[testType] =
                      state.questionsResponse.instructions;
                  loadedTests++;
                  if (loadedTests == tests.length) {
                    isLoading = false;
                  }
                }
              });
            } else if (state is MultipleTestsLoading) {
              _isDialogShowing = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                const Center(child: CircularProgressIndicator()),
              );
            } else if (state is MultipleTestsSuccess) {
              if (_isDialogShowing) {
                _isDialogShowing = false;
                Navigator.pop(context); // close loading dialog
              }
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.testComplete,
                arguments: state.results.first,
              );
            } else if (state is MultipleTestsFailure) {
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
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentTest = tests[currentTestIndex];
            final currentTestType = currentTest['type'] as String;
            final questions = allQuestions[currentTestType] ?? [];

            if (questions.isEmpty) {
              return const Center(child: Text('No questions available'));
            }

            final progress = (currentQuestionIndex + 1) / questions.length;
            // FIX: resolve current question entity to access q_id
            final currentQuestion = questions[currentQuestionIndex];
            // FIX: answer key uses testIndex + q_id (not page index)
            final currentAnswerKey =
                '${currentTestIndex}_${currentQuestion.qId}';

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentQuestionIndex > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else if (currentTestIndex > 0) {
                        setState(() {
                          currentTestIndex--;
                          final prevTestType =
                          tests[currentTestIndex]['type'] as String;
                          currentQuestionIndex =
                              (allQuestions[prevTestType]?.length ?? 1) - 1;
                        });
                        pageController.jumpToPage(currentQuestionIndex);
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
                  Text(currentTest['title'] as String,
                      style: AppTextStyles.nunito30w900Black),
                  SizedBox(height: 5.h),
                  Text(
                    allInstructions[currentTestType] ?? '',
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
                    'Test ${currentTestIndex + 1}/${tests.length} - Question: ${currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primaryBlue,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: questions.length,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          currentQuestionIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final qId = question.qId;
                        final key = '${currentTestIndex}_$qId';

                        return Column(
                          key: ValueKey(key),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.question,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            // FIX: answer values 'yes/no/sometimes' to match API
                            AnswerOption(
                              label: 'Yes',
                              selected: answers[key] == 'yes',
                              onTap: () {
                                setState(() => answers[key] = 'yes');
                              },
                            ),
                            SizedBox(height: 15.h),
                            AnswerOption(
                              label: 'No',
                              selected: answers[key] == 'no',
                              onTap: () {
                                setState(() => answers[key] = 'no');
                              },
                            ),
                            SizedBox(height: 15.h),
                            AnswerOption(
                              label: 'Sometimes',
                              selected: answers[key] == 'sometimes',
                              onTap: () {
                                setState(() => answers[key] = 'sometimes');
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
                      if (currentQuestionIndex > 0 || currentTestIndex > 0)
                        CustomButtonSmallTest(
                          text: AppStrings.previousButton,
                          onTap: () {
                            if (currentQuestionIndex > 0) {
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      const Spacer(),
                      CustomButtonSmallTest(
                        text: currentQuestionIndex == questions.length - 1
                            ? (currentTestIndex == tests.length - 1
                            ? AppStrings.viewSubmitButton
                            : AppStrings.nextTestButton)
                            : AppStrings.nextButton,
                        // FIX: check using q_id-based key
                        onTap: answers[currentAnswerKey] == null
                            ? null
                            : () {
                          if (currentQuestionIndex <
                              questions.length - 1) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          } else if (currentTestIndex <
                              tests.length - 1) {
                            setState(() {
                              currentTestIndex++;
                              currentQuestionIndex = 0;
                            });
                            pageController.jumpToPage(0);
                          } else {
                            // Build submission map keyed by real q_id
                            final Map<String, Map<int, String>>
                            allTestsAnswers = {};
                            for (int i = 0; i < tests.length; i++) {
                              final testType =
                              tests[i]['type'] as String;
                              final testQuestions =
                                  allQuestions[testType] ?? [];
                              final Map<int, String> testAnswers = {};
                              for (final q in testQuestions) {
                                final key = '${i}_${q.qId}';
                                if (answers.containsKey(key)) {
                                  // FIX: key by q_id not loop index
                                  testAnswers[q.qId] = answers[key]!;
                                }
                              }
                              allTestsAnswers[testType] = testAnswers;
                            }
                            context.read<TestCubit>().submitMultipleTests(
                              childId: widget.child.id!,
                              age: _calculateAge(widget.child.birthDate),
                              sex: _convertGender(widget.child.gender),
                              jaundice: 'no',
                              familyAsd: 'no',
                              allTestsAnswers: allTestsAnswers,
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
          },
        ),
      ),
    );
  }
}