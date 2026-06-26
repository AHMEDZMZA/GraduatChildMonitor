import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/activity_model.dart';
import '../../../../core/navigation/app_routes.dart';
import '../cubit/activity_cubit.dart';
import '../state/activity_state.dart';
import 'activity_list_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentChildActivitiesView extends StatefulWidget {
  const ParentChildActivitiesView({super.key});

  @override
  State<ParentChildActivitiesView> createState() =>
      _ParentChildActivitiesViewState();
}

class _ParentChildActivitiesViewState extends State<ParentChildActivitiesView> {
  late List<ActivityModel> activities;
  List<String> completedActivities = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedActivities();
    // Use addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ActivityCubit>().getActivitiesByType('PARENT_CHILD');
      }
    });
    activities = [];
  }

  /// Split a description string into ActivityStepModel list.
  /// Uses newlines first; falls back to sentence splitting on '. '.
  List<ActivityStepModel> _descriptionToSteps(
    String description,
    String activityTitle,
    String image,
  ) {
    if (description.trim().isEmpty) return [];

    List<String> parts = description
        .split(RegExp(r'\n+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (parts.length == 1 && parts.first.length > 60) {
      parts = parts.first
          .split(RegExp(r'\.\s+'))
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .map((l) => l.endsWith('.') ? l : '$l.')
          .toList();
    }

    return parts
        .map(
          (part) => ActivityStepModel(
            image: image,
            title: activityTitle,
            description: part,
            note: '',
          ),
        )
        .toList();
  }

  Future<void> _loadCompletedActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getString('childId') ?? '';
    if (childId.isNotEmpty) {
      final key = 'completed_activities_$childId';
      setState(() {
        completedActivities = prefs.getStringList(key) ?? [];
      });
    }
  }

  double get progressValue {
    if (activities.isEmpty) return 0;
    final done = activities.where((e) => e.completed).length;
    return done / activities.length;
  }

  int get completedCount => activities.where((e) => e.completed).length;

  Future<void> _openActivity(int index) async {
    final ActivityModel selected = activities[index];

    final bool? completed = await Navigator.pushNamed<bool>(
      context,
      AppRoutes.activityDetails,
      arguments: selected,
    );

    if (completed == true) {
      await _loadCompletedActivities();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0.h),
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
                    color: ColorManager.darkText,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Parent-Child Activities',
                style: AppTextStyles.nunito30w900Black,
              ),
              SizedBox(height: 4.h),
              Text(
                'Simple activities designed to strengthen your bond with your child.',
                style: AppTextStyles.nunito14w400Grey.copyWith(fontSize: 11.sp),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<ActivityCubit, ActivityState>(
                  buildWhen: (previous, current) =>
                      current is ActivitiesByTypeLoaded ||
                      (current is ActivityLoading && activities.isEmpty) ||
                      (current is ActivityError && activities.isEmpty),
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryBlue,
                        ),
                      );
                    } else if (state is ActivitiesByTypeLoaded) {
                      activities = state.activities
                          .map(
                            (entity) => ActivityModel(
                              id: entity.id,
                              title: entity.title,
                              shortDescription: entity.description ?? '',
                              image: AppAssets.activities1,
                              duration:
                                  '⏱ Duration: ${entity.durationMinutes} minutes',
                              difficulty:
                                  '⚡ Difficulty: ${entity.difficultyLevel}',
                              suitableAge:
                                  '👶 Suitable Age: ${entity.minAge}–${entity.maxAge} years',
                              steps: entity.steps.isNotEmpty
                                  ? entity.steps
                                      .map(
                                        (step) => ActivityStepModel(
                                          image: AppAssets.activities1,
                                          title: entity.title,
                                          description: step,
                                          note: step,
                                        ),
                                      )
                                      .toList()
                                  : _descriptionToSteps(
                                      entity.description ?? '',
                                      entity.title,
                                      AppAssets.activities1,
                                    ),
                              completed: completedActivities.contains(
                                entity.id,
                              ),
                              highlighted: false,
                            ),
                          )
                          .toList();
                    }

                    if (activities.isEmpty) {
                      if (state is ActivityError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: AppTextStyles.nunito14w400Grey,
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'No parent-child activities available',
                          style: AppTextStyles.nunito14w400Grey,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 8,
                            backgroundColor: ColorManager.lightGray,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              ColorManager.primaryBlue,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Activities Completed: $completedCount/${activities.length}',
                          style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),
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
