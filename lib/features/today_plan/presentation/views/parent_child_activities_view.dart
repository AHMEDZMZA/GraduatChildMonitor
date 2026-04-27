import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/activity_model.dart';
import 'activity_details_view.dart';
import 'activity_list_item.dart';

class ParentChildActivitiesView extends StatefulWidget {
  const ParentChildActivitiesView({super.key});

  @override
  State<ParentChildActivitiesView> createState() =>
      _ParentChildActivitiesViewState();
}

class _ParentChildActivitiesViewState extends State<ParentChildActivitiesView> {
  late List<ActivityModel> activities;

  @override
  void initState() {
    super.initState();
    activities = [
      const ActivityModel(
        title: 'Emotion Sharing Time',
        shortDescription:
            'A guided activity that helps your child express feelings in a safe and supportive way.',
        image: AppAssets.activities1,
        duration: '⏱ Duration: 10 minutes',
        difficulty: '⚡ Difficulty: Easy',
        suitableAge: '👶 Suitable Age: 4–8 years',
        steps: [
          ActivityStepModel(
            image: AppAssets.activities1,
            title: 'Emotion Sharing Time',
            description:
                'Sit with your child in a calm place and introduce the feelings cards.',
            note: 'Encourage your child to choose freely without pressure.',
          ),
          ActivityStepModel(
            image: AppAssets.activities1,
            title: 'Emotion Sharing Time',
            description:
                'Talk together about a time your child felt the chosen emotion.',
            note: 'Encourage your child to explain\n freely without pressure.',
          ),
          ActivityStepModel(
            image: AppAssets.activities1,
            title: 'Emotion Sharing Time',
            description:
                'Ask your child what helped them feel better and what they can do next time.',
            note: 'Praise every effort and keep the tone calm and positive.',
          ),
          ActivityStepModel(
            image: AppAssets.activities1,
            title: 'Emotion Sharing Time',
            description:
                'End with a positive note and hug to reinforce trust and comfort.',
            note: 'Encourage your child to express freely without pressure.',
          ),
        ],
        highlighted: true,
      ),
      const ActivityModel(
        title: 'Follow My Lead',
        shortDescription:
            'An interactive activity that builds trust and improves attention through shared play.',
        image: AppAssets.activities2,
        duration: '⏱ Duration: 10 minutes',
        difficulty: '⚡ Difficulty: Easy',
        suitableAge: '👶 Suitable Age: 4–8 years',
        steps: [
          ActivityStepModel(
            image: AppAssets.activities2,
            title: 'Follow My Lead',
            description:
                'Choose a simple movement and ask your child to copy it.',
            note: 'Use clear gestures and keep it fun.',
          ),
          ActivityStepModel(
            image: AppAssets.activities2,
            title: 'Follow My Lead',
            description: 'Take turns letting your child lead and you follow.',
            note: 'Celebrate every successful try.',
          ),
          ActivityStepModel(
            image: AppAssets.activities2,
            title: 'Follow My Lead',
            description:
                'Increase the number of movements slowly to challenge attention.',
            note: 'Stop if your child seems tired.',
          ),
          ActivityStepModel(
            image: AppAssets.activities2,
            title: 'Follow My Lead',
            description:
                'Finish with praise and a calm transition to the next activity.',
            note: 'Keep the ending positive and encouraging.',
          ),
        ],
        completed: true,
      ),
      const ActivityModel(
        title: 'Emotion Sharing Time',
        shortDescription:
            'A guided activity that helps your child express feelings in a safe and supportive way.',
        image: AppAssets.activities3,
        duration: '⏱ Duration: 10 minutes',
        difficulty: '⚡ Difficulty: Easy',
        suitableAge: '👶 Suitable Age: 4–8 years',
        steps: [
          ActivityStepModel(
            image: AppAssets.activities3,
            title: 'Emotion Sharing Time',
            description:
                'Use emotion cards to help your child identify how they feel.',
            note: 'Offer reassurance and support.',
          ),
          ActivityStepModel(
            image: AppAssets.activities3,
            title: 'Emotion Sharing Time',
            description:
                'Discuss a recent moment where your child felt that emotion.',
            note: 'Let them answer in their own words.',
          ),
          ActivityStepModel(
            image: AppAssets.activities3,
            title: 'Emotion Sharing Time',
            description: 'Ask what could help when that feeling happens again.',
            note: 'Suggest simple coping strategies.',
          ),
          ActivityStepModel(
            image: AppAssets.activities3,
            title: 'Emotion Sharing Time',
            description: 'Close with positive reinforcement and validation.',
            note: 'Keep it calm and safe.',
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
        activities =
            activities.asMap().entries.map((entry) {
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
                'Parent-Child Activities',
                style: AppTextStyles.nunito30w900Black,
              ),
              const SizedBox(height: 4),
              Text(
                'Simple activities designed to strengthen your bond with your child.',
                style: AppTextStyles.nunito14w400Grey.copyWith(fontSize: 11),
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
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
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
