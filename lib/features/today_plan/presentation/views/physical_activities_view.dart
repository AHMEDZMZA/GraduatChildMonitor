import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/activity_model.dart';
import 'activity_details_view.dart';
import 'activity_list_item.dart';

class PhysicalActivitiesView extends StatefulWidget {
  const PhysicalActivitiesView({super.key});

  @override
  State<PhysicalActivitiesView> createState() => _PhysicalActivitiesViewState();
}

class _PhysicalActivitiesViewState extends State<PhysicalActivitiesView> {
  late List<ActivityModel> activities;

  @override
  void initState() {
    super.initState();
    activities = [
      const ActivityModel(
        title: 'Jumping Jacks',
        shortDescription:
        'A guided activity that helps your child exercise, stay focused, and improve body control.',
        image: AppAssets.physicalActivities1,
        duration: '⏱ Duration: 10 minutes',
        difficulty: '⚡ Difficulty: Easy',
        suitableAge: '👶 Suitable Age: 4–8 years',
        steps: [
          ActivityStepModel(
            image: AppAssets.physicalActivities1,
            title: 'Jumping Jacks',
            description:
            'Sit with your child in a calm place and introduce the movement.',
            note: 'Encourage your child to choose freely without pressure.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities1,
            title: 'Jumping Jacks',
            description:
            'Talk together about how to move your child into the chosen exercise.',
            note: 'Encourage your child to explain freely without pressure.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities1,
            title: 'Jumping Jacks',
            description:
            'End with a positive note and hug to reinforce trust and motivation.',
            note: 'Encourage your child to express freely without pressure.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities1,
            title: 'Jumping Jacks',
            description:
            'Finish the activity with praise and help your child cool down calmly.',
            note: 'Celebrate the effort and keep the moment positive.',
          ),
        ],
        highlighted: true,
      ),
      const ActivityModel(
        title: 'Animal Walks',
        shortDescription:
        'An interactive activity that builds coordination and supports active movement through playful walking styles.',
        image: AppAssets.physicalActivities2,
        duration: '⏱ Duration: 10 minutes',
        difficulty: '⚡ Difficulty: Easy',
        suitableAge: '👶 Suitable Age: 4–8 years',
        steps: [
          ActivityStepModel(
            image: AppAssets.physicalActivities2,
            title: 'Animal Walks',
            description:
            'Choose an animal movement and ask your child to copy it slowly.',
            note: 'Use simple movements and make it fun.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities2,
            title: 'Animal Walks',
            description:
            'Take turns imitating different animals together.',
            note: 'Praise each correct movement.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities2,
            title: 'Animal Walks',
            description:
            'Increase variety gradually to improve focus and body control.',
            note: 'Pause if your child gets tired.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities2,
            title: 'Animal Walks',
            description:
            'Finish with a calm stretch and kind feedback.',
            note: 'Keep the ending positive and supportive.',
          ),
        ],
        completed: true,
      ),
      const ActivityModel(
        title: 'Balance Challenge',
        shortDescription:
        'A guided activity that helps your child improve balance, stability, and body awareness.',
        image: AppAssets.physicalActivities3,
        duration: '⏱ Duration: 10 minutes',
        difficulty: '⚡ Difficulty: Easy',
        suitableAge: '👶 Suitable Age: 4–8 years',
        steps: [
          ActivityStepModel(
            image: AppAssets.physicalActivities3,
            title: 'Balance Challenge',
            description:
            'Ask your child to stand on one foot for a few seconds.',
            note: 'Stay nearby and support if needed.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities3,
            title: 'Balance Challenge',
            description:
            'Count together and switch sides slowly.',
            note: 'Keep your tone encouraging.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities3,
            title: 'Balance Challenge',
            description:
            'Add simple arm movements to increase coordination.',
            note: 'Do not rush the activity.',
          ),
          ActivityStepModel(
            image: AppAssets.physicalActivities3,
            title: 'Balance Challenge',
            description:
            'End with praise and a short rest.',
            note: 'Celebrate progress, not perfection.',
          ),
        ],
      ),
    ];
  }

  double get progressValue {
    if (activities.isEmpty) return 0;
    final done = activities.where((e) => e.completed).length;
    return done / activities.length;
  }

  int get completedCount => activities.where((e) => e.completed).length;

  Future<void> _openActivity(int index) async {
    final ActivityModel selected = activities[index];

    final bool? completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityDetailsView(activity: selected),
      ),
    );

    if (completed == true) {
      setState(() {
        activities = activities.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;

          if (i == index) {
            return item.copyWith(completed: true, highlighted: false);
          }

          if (i == index + 1) {
            return item.copyWith(highlighted: true);
          }

          return item.copyWith(highlighted: false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: ColorManager.buttonBlue,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Physical Activities',
                style: AppTextStyles.nunito30w900Black,
              ),
              const SizedBox(height: 4),
              Text(
                'Daily physical exercises designed to boost energy, focus, and coordination.',
                style: AppTextStyles.nunito14w400Grey.copyWith(
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  backgroundColor: ColorManager.lightGray,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorManager.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Activities Completed: $completedCount/${activities.length}',
                style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return ActivityListItem(
                      item: activities[index],
                      onTap: () => _openActivity(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}