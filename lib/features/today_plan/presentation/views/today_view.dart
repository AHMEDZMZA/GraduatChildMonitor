import 'package:child_monitor_app/features/today_plan/presentation/views/parent_child_activities_view.dart';
import 'package:child_monitor_app/features/today_plan/presentation/views/physical_activities_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../home/presentation/widgets/home_banner.dart';
import '../../data/today_plan_model.dart';
import '../widgets/today_plan_card.dart';
import 'interactive_quiz_today_view.dart';

class TodayView extends StatelessWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TodayPlanModel> plans = [
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
      backgroundColor: ColorManager.backgroundWhite,
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
                        color: Colors.black87,
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

                //TodayPlanCard(item: TodayPlanModel(title: title, description: description, image: image, points: points), onTap: () {})
                TodayPlanCard(item: plans[0], onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PhysicalActivitiesView(),
                    ),
                  );

                }),
                TodayPlanCard(item: plans[1], onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParentChildActivitiesView(),
                    ),
                  );
                }),
                TodayPlanCard(
                  item: plans[2],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InteractiveQuizTodayView(),
                      ),
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
