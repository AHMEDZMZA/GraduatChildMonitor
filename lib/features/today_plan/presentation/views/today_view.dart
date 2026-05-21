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
    final List<TodayPlanModel> defaultPlans = [
      const TodayPlanModel(
        title: 'Physical Activities',
        description:
            'Simple movement-based activities that help your child stay active and focused.',
        image: AppAssets.todayPlan1,
        points: [
          'Boosts concentration',
          'Reduces hyperactivity',
          'Safe and fun',
          'Examples: Running - Jumping - Kids Yoga',
        ],
      ),
      const TodayPlanModel(
        title: 'Parent-Child Activities',
        description:
            'Interactive activities designed to strengthen your bond and support your child\'s development.',
        image: AppAssets.todayPlan2,
        points: [
          'Improves interaction',
          'Builds trust',
          'Quantity time together',
          'Examples: Shared play - Guided conversation - Cooperative tasks',
        ],
      ),
      const TodayPlanModel(
        title: 'Interactive Quizzes',
        description:
            'Short and engaging quizzes that build your child\'s focus and response skills.',
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

                const SizedBox(height: 24),

                const CustomText(
                  text: 'Today’s Plan',
                  style: AppTextStyles.nunito30w900Black,
                ),

                const SizedBox(height: 6),

                const CustomText(
                  text: 'Therapeutic Activities for Your Child',
                  style: AppTextStyles.nunito14w400Grey,
                ),

                const SizedBox(height: 18),

                const HomeBanner(),

                const SizedBox(height: 22),

                BlocBuilder<ActivityCubit, ActivityState>(
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryBlue,
                        ),
                      );
                    } else if (state is AllActivitiesLoaded) {
                      final activities = state.activities;

                      // تصنيف الأنشطة حسب النوع
                      final physicalActivities = activities
                          .where((a) => a.activityType == 'PHYSICAL')
                          .toList();
                      final parentChildActivities = activities
                          .where((a) => a.activityType == 'PARENT_CHILD')
                          .toList();

                      // بناء بيانات الخطط من API مع إظهار كافة الفئات دائماً
                      final apiPlans = [
                        TodayPlanModel(
                          title: 'Physical Activities',
                          description:
                              'Simple movement-based activities that help your child stay active and focused.',
                          image: AppAssets.todayPlan1,
                          points: physicalActivities.isNotEmpty
                              ? physicalActivities
                                    .map((a) => a.benefits ?? 'Activity')
                                    .toList()
                              : const [
                                  'Boosts concentration',
                                  'Reduces hyperactivity',
                                  'Safe and fun',
                                  'Examples: Running - Jumping - Kids Yoga',
                                ],
                        ),
                        TodayPlanModel(
                          title: 'Parent-Child Activities',
                          description:
                              'Interactive activities designed to strengthen your bond and support your child\'s development.',
                          image: AppAssets.todayPlan2,
                          points: parentChildActivities.isNotEmpty
                              ? parentChildActivities
                                    .map((a) => a.benefits ?? 'Activity')
                                    .toList()
                              : const [
                                  'Improves interaction',
                                  'Builds trust',
                                  'Quantity time together',
                                  'Examples: Shared play - Guided conversation - Cooperative tasks',
                                ],
                        ),
                        const TodayPlanModel(
                          title: 'Interactive Quizzes',
                          description:
                              'Short and engaging quizzes that build your child\'s focus and response skills.',
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
                              if (plan.title == 'Physical Activities') {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.physicalActivities,
                                ).then((_) => _loadActivities());
                              } else if (plan.title ==
                                  'Parent-Child Activities') {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.parentChildActivities,
                                ).then((_) => _loadActivities());
                              } else if (plan.title == 'Interactive Quizzes') {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.interactiveQuizToday,
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
