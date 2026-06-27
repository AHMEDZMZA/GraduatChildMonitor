import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../home/presentation/widgets/home_banner.dart';
import '../../data/today_plan_model.dart';
import '../widgets/today_plan_card.dart';
import '../cubit/activity_cubit.dart';
import '../state/activity_state.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivities();
    });
  }

  Future<void> _loadActivities() async {
    if (mounted) {
      context.read<ActivityCubit>().getAllActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = context.read<HomeCubit>().state;
    String? selectedChildId;
    if (homeState is HomeSuccess) {
      selectedChildId =
          homeState.homeData.selectedChildId ??
          (homeState.homeData.children.isNotEmpty
              ? homeState.homeData.children.first.id
              : null);
    }

    final List<TodayPlanModel> defaultPlans = [
      TodayPlanModel(
        title: 'physical_activities'.tr(),
        description:
            'today_plan_desc_1'.tr(),
        image: AppAssets.todayPlan1,
        points: [
          'Boosts concentration',
          'Reduces hyperactivity',
          'Safe and fun',
          'Examples: Running - Jumping - Kids Yoga',
        ],
      ),
      TodayPlanModel(
        title: 'parent_child_activities'.tr(),
        description:
            'today_plan_desc_2'.tr(),
        image: AppAssets.todayPlan2,
        points: [
          'Improves interaction',
          'Builds trust',
          'Quantity time together',
          'Examples: Shared play - Guided conversation - Cooperative tasks',
        ],
      ),
      TodayPlanModel(
        title: 'interactive_quizzes'.tr(),
        description:
            'today_plan_desc_3'.tr(),
        image: AppAssets.todayPlan3,
        points: [
          '3 questions per quiz',
          'Fun and educational',
          'Child-friendly',
          'Parent guidance recommended',
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: ColorManager.buttonBlue,
                      radius: 18,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: ColorManager.darkText,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                CustomText(
                  text: 'todays_plan'.tr(),
                  style: AppTextStyles.nunito30w900Black,
                ),

                SizedBox(height: 6.h),

                CustomText(
                  text: 'therapeutic_activities'.tr(),
                  style: AppTextStyles.nunito14w400Grey,
                ),

                SizedBox(height: 18.h),

                const HomeBanner(),

                SizedBox(height: 22.h),

                BlocBuilder<ActivityCubit, ActivityState>(
                  buildWhen: (previous, current) =>
                      current is AllActivitiesLoaded ||
                      (current is ActivityLoading &&
                          previous is! AllActivitiesLoaded),
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryBlue,
                        ),
                      );
                    } else if (state is AllActivitiesLoaded) {
                      // بناء بيانات الخطط من API مع إظهار كافة الفئات دائماً
                      final apiPlans = [
                        TodayPlanModel(
                          title: 'physical_activities'.tr(),
                          description:
                              'today_plan_desc_1'.tr(),
                          image: AppAssets.todayPlan1,
                          points: const [
                            'Boosts concentration',
                            'Reduces hyperactivity',
                            'Safe and fun',
                            'Examples: Running - Jumping - Kids Yoga',
                          ],
                        ),
                        TodayPlanModel(
                          title: 'parent_child_activities'.tr(),
                          description:
                              'today_plan_desc_2'.tr(),
                          image: AppAssets.todayPlan2,
                          points: const [
                            'Improves interaction',
                            'Builds trust',
                            'Quantity time together',
                            'Examples: Shared play - Guided conversation - Cooperative tasks',
                          ],
                        ),
                        TodayPlanModel(
                          title: 'interactive_quizzes'.tr(),
                          description:
                              'today_plan_desc_3'.tr(),
                          image: AppAssets.todayPlan3,
                          points: [
                            '3 questions per quiz',
                            'Fun and educational',
                            'Child-friendly',
                            'Parent guidance recommended',
                          ],
                        ),
                      ];

                      return Column(
                        children: apiPlans.map((plan) {
                          return TodayPlanCard(
                            item: plan,
                            onTap: () {
                              if (plan.title == 'physical_activities'.tr()) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.physicalActivities,
                                ).then((_) => _loadActivities());
                              } else if (plan.title ==
                                  'parent_child_activities'.tr()) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.parentChildActivities,
                                ).then((_) => _loadActivities());
                              } else if (plan.title == 'interactive_quizzes'.tr()) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.interactiveQuizToday,
                                  arguments: selectedChildId,
                                ).then((_) => _loadActivities());
                              }
                            },
                          );
                        }).toList(),
                      );
                    } else if (state is ActivityError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: AppTextStyles.nunito14w400Grey,
                        ),
                      );
                    }

                    // Default plans as fallback
                    return Column(
                      children: [
                        TodayPlanCard(
                          item: defaultPlans[0],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.physicalActivities,
                            ).then((_) => _loadActivities());
                          },
                        ),
                        TodayPlanCard(
                          item: defaultPlans[1],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.parentChildActivities,
                            ).then((_) => _loadActivities());
                          },
                        ),
                        TodayPlanCard(
                          item: defaultPlans[2],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.interactiveQuizToday,
                              arguments: selectedChildId,
                            ).then((_) => _loadActivities());
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


