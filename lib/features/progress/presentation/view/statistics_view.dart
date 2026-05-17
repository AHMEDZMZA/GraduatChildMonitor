import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              const Center(
                child: CustomText(
                  text: 'Progress Statistics',
                  style: AppTextStyles.nunito30w900Black,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
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
                            const SizedBox(height: 24),
                            _buildSectionTitle('Activity Statistics'),
                            _buildStatsCard(
                              completed:
                                  progress.activityStats.completedActivities,
                              total: progress.activityStats.totalActivities,
                              percentage:
                                  progress.activityStats.completionPercentage,
                            ),
                            const SizedBox(height: 24),
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
      padding: const EdgeInsets.only(bottom: 12),
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
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Status: ${status.toUpperCase()}',
                style: AppTextStyles.nunito16w900Green.copyWith(
                  color: statusColor,
                ),
              ),
              const CustomText(
                text: 'Based on monthly assessments',
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
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: 'Activity Completion',
                style: AppTextStyles.nunito16w900Black,
              ),
              CustomText(
                text: '$completed/$total',
                style: AppTextStyles.nunito16w900Green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: ColorManager.lightGray,
            color: ColorManager.primaryBlue,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: ColorManager.gold),
              const SizedBox(width: 8),
              CustomText(
                text: 'Overall Improvement: ${improvement.toStringAsFixed(1)}%',
                style: AppTextStyles.nunito16w900Black,
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(text: text, style: AppTextStyles.nunito14w400Grey),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
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
