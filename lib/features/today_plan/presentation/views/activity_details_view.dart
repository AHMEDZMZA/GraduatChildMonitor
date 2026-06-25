import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../data/activity_model.dart';
import '../../../../core/navigation/app_routes.dart';
import '../cubit/activity_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityDetailsView extends StatefulWidget {
  final ActivityModel activity;

  const ActivityDetailsView({super.key, required this.activity});

  @override
  State<ActivityDetailsView> createState() => _ActivityDetailsViewState();
}

class _ActivityDetailsViewState extends State<ActivityDetailsView> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.activity.completed;
  }

  Future<void> _startActivity() async {
    final bool? done = await Navigator.pushNamed<bool>(
      context,
      AppRoutes.activitySteps,
      arguments: widget.activity,
    );

    if (done == true) {
      // Get childId from shared preferences or pass it as parameter
      final prefs = await SharedPreferences.getInstance();
      final childId = prefs.getString('childId') ?? '';

      if (childId.isNotEmpty) {
        if (!mounted) return;
        // Call the API to mark activity as completed
        context.read<ActivityCubit>().completeActivity(
          childId,
          widget.activity.id,
        );

        // Save completed status locally in SharedPreferences
        final key = 'completed_activities_$childId';
        final completedList = prefs.getStringList(key) ?? [];
        if (!completedList.contains(widget.activity.id)) {
          completedList.add(widget.activity.id);
          await prefs.setStringList(key, completedList);
        }
      }

      setState(() {
        isCompleted = true;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, isCompleted),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: ColorManager.buttonBlue,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Image.asset(
                    widget.activity.image,
                    width: 261,
                    height: 191,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  widget.activity.title,
                  style: AppTextStyles.nunito30w900Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Activity Info',
                  style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                _InfoRow(icon: Icons.circle, text: widget.activity.duration),
                SizedBox(height: 4.h),
                _InfoRow(icon: Icons.circle, text: widget.activity.difficulty),
                SizedBox(height: 4.h),
                _InfoRow(icon: Icons.circle, text: widget.activity.suitableAge),
                if (isCompleted) ...[
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: ColorManager.brightTeal,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Completed',
                        style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                          color: ColorManager.brightTeal,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 90.h),

                CustomButton(
                  text: isCompleted ? 'Done' : 'Start Activity',
                  onTap: () {
                    if (isCompleted) {
                      Navigator.pop(context, true);
                    } else {
                      _startActivity();
                    }
                  },
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 6, color: Theme.of(context).iconTheme.color),
        SizedBox(width: 6.w),
        Text(
          text,
          style: AppTextStyles.nunito12w600overlayGray66.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
