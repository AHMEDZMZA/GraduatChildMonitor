import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsView extends StatefulWidget {
  final String childId;
  const StatisticsView({super.key, required this.childId});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressCubit>().fetchProgress(widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
              Center(
                child: CustomText(
                  text: 'progress_statistics'.tr(),
                  style: AppTextStyles.nunito30w900Black,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: BlocBuilder<ProgressCubit, ProgressState>(
                  builder: (context, state) {
                    if (state is ProgressLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProgressError) {
                      return Center(child: Text(state.message));
                    } else if (state is ProgressLoaded) {
                      final progress = state.progress;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Improvement Trend'),
                            _buildTrendCard(progress.trend.status),
                            SizedBox(height: 24.h),
                            _buildSectionTitle('Activity Statistics'),
                            _buildStatsCard(
                              completed:
                                  progress.activityStats.completedActivities,
                              total: progress.activityStats.totalActivities,
                              percentage:
                                  progress.activityStats.completionPercentage,
                            ),
                            SizedBox(height: 24.h),
                            _buildSectionTitle('Progress Summary'),
                            _buildSummaryCard(
                              progress.summary.summaryText,
                              progress.summary.improvementPercentage,
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomText(text: title, style: AppTextStyles.nunito20w900Black),
    );
  }

  Widget _buildTrendCard(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'improving':
        statusColor = ColorManager.brightTeal;
        statusIcon = Icons.trending_up;
        break;
      case 'declining':
        statusColor = ColorManager.errorRed;
        statusIcon = Icons.trending_down;
        break;
      default:
        statusColor = ColorManager.vibrantOrange;
        statusIcon = Icons.trending_flat;
    }

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 40),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: '${'status'.tr()} ${status.toUpperCase()}',
                style: AppTextStyles.nunito16w900Green.copyWith(
                  color: statusColor,
                ),
              ),
              CustomText(
                text: 'based_on_monthly'.tr(),
                style: AppTextStyles.nunito12w600overlayGray66,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required int completed,
    required int total,
    required double percentage,
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'activity_completion'.tr(),
                style: AppTextStyles.nunito16w900Black,
              ),
              CustomText(
                text: '$completed/$total',
                style: AppTextStyles.nunito16w900Green,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: ColorManager.lightGray,
            color: ColorManager.primaryBlue,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6.r),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: CustomText(
              text: '${percentage.toStringAsFixed(1)}%',
              style: AppTextStyles.nunito14w400Grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String text, double improvement) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: ColorManager.gold),
              SizedBox(width: 8.w),
              CustomText(
                text: '${'overall_improvement'.tr()} ${improvement.toStringAsFixed(1)}%',
                style: AppTextStyles.nunito16w900Black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(text: text, style: AppTextStyles.nunito14w400Grey),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(
        color: ColorManager.primaryBlue.withValues(alpha: 0.3),
      ),
      boxShadow: [
        BoxShadow(
          color: ColorManager.black8,
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

