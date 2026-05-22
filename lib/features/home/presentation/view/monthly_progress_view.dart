import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../cubit/monthly_assessment_cubit.dart';
import '../cubit/monthly_assessment_state.dart';
import '../widgets/progress_item.dart';

class MonthlyProgressView extends StatefulWidget {
  final ChildProfileEntity child;
  const MonthlyProgressView({super.key, required this.child});

  @override
  State<MonthlyProgressView> createState() => _MonthlyProgressViewState();
}

class _MonthlyProgressViewState extends State<MonthlyProgressView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MonthlyAssessmentCubit>()..getHistory(widget.child.id),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
                    },
                    child: const CircleAvatar(
                      backgroundColor: ColorManager.buttonBlue,
                      radius: 18,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: CustomText(
                    text: 'Your Child’s Monthly Assessments',
                    style: AppTextStyles.nunito30w900Black,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 6),

                const Center(
                  child: CustomText(
                    text: 'Review your child’s monthly progress here.',
                    style: AppTextStyles.nunito14w400Grey,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 28),

                Expanded(
                  child: BlocBuilder<MonthlyAssessmentCubit, MonthlyAssessmentState>(
                    builder: (context, state) {
                      if (state is MonthlyAssessmentHistoryLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primaryBlue,
                          ),
                        );
                      } else if (state is MonthlyAssessmentHistoryError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: state.message,
                                style: AppTextStyles.nunito16w900Green.copyWith(
                                  color: Colors.redAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<MonthlyAssessmentCubit>().getHistory(widget.child.id);
                                },
                                child: const CustomText(
                                  text: 'Retry',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is MonthlyAssessmentHistoryLoaded) {
                        final list = state.response.history;
                        final bool isEmpty = list.isEmpty;
                        if (isEmpty) {
                          return const Center(child: _EmptyState());
                        }
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];

                            return ProgressItem(
                              item: item,
                              highlighted: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });

                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.monthlyProgressDetails,
                                  arguments: item,
                                );
                              },
                            );
                          },
                        );
                      }
                      return const Center(child: _EmptyState());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 240,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.primaryBlue),
      ),
      alignment: Alignment.center,
      child: const CustomText(
        text: 'No monthly assessment yet',
        style: AppTextStyles.nunito16w900Green,
      ),
    );
  }
}