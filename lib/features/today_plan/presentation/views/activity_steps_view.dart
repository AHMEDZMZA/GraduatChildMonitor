import 'package:easy_localization/easy_localization.dart';
import 'package:child_monitor_app/core/helpers/notification_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../data/activity_model.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityStepsView extends StatefulWidget {
  final ActivityModel activity;

  const ActivityStepsView({super.key, required this.activity});

  @override
  State<ActivityStepsView> createState() => _ActivityStepsViewState();
}

class _ActivityStepsViewState extends State<ActivityStepsView> {
  final PageController controller = PageController();
  int currentStep = 0;

  /// Split a raw description string into clean bullet lines.
  /// Handles newlines, period-separated sentences, and numbered lists.
  List<String> _splitDescription(String raw) {
    if (raw.trim().isEmpty) return [];

    // Try splitting by newline first
    var lines = raw
        .split(RegExp(r'\n+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // If only one line and it's long, try splitting by '. '
    if (lines.length == 1 && lines.first.length > 60) {
      lines = lines.first
          .split(RegExp(r'\.\s+'))
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .map((l) => l.endsWith('.') ? l : '$l.')
          .toList();
    }

    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.activity.steps;
    final total = steps.length;

    // ── Guard: no steps returned from API ─────────────────────────────────
    if (total == 0) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                const Spacer(),
                Icon(
                  Icons.info_outline_rounded,
                  size: 60,
                  color: ColorManager.primaryBlue.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16.h),
                Text(
                  widget.activity.title,
                  style: AppTextStyles.nunito30w900Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'No steps available for this activity.\nYou can still mark it as completed.',
                  style: AppTextStyles.nunito14w400Grey,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                CustomButtonSmallTest(
                  text: 'submit'.tr(),
                  onTap: () async {
                    await NotificationHelper.showNotification(
                      id: 1,
                      title: 'activity_completed'.tr(),
                      body: 'Great job completing ${widget.activity.title}!',
                    );
                    if (!context.mounted) return;
                    final bool? done = await Navigator.pushNamed<bool>(
                      context,
                      AppRoutes.activityDone,
                      arguments: {
                        'title': widget.activity.title,
                        'image': widget.activity.image,
                      },
                    );
                    if (done == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      );
    }
    // ──────────────────────────────────────────────────────────────────────

    final progress = (currentStep + 1) / total;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0.h),
          child: Column(
            children: [
              // ── Back button ──────────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (currentStep == 0) {
                      Navigator.pop(context);
                    } else {
                      controller.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
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

              SizedBox(height: 10.h),

              // ── Activity title (always visible at top) ───────────────────
              Text(
                widget.activity.title,
                style: AppTextStyles.nunito30w900Black.copyWith(
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 10.h),

              // ── Progress bar ─────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: ColorManager.lightGray,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorManager.primaryBlue,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Step ${currentStep + 1} of $total',
                  style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // ── Page content ─────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: total,
                  onPageChanged: (index) {
                    setState(() {
                      currentStep = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final bullets = _splitDescription(step.description);

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.asset(
                              step.image,
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Step title (sub-title for the step)
                          if (step.title.isNotEmpty &&
                              step.title != widget.activity.title)
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                step.title,
                                style: AppTextStyles.nunito16w900Black.copyWith(
                                  fontSize: 17.sp,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),

                          // Step description — split into bullet points
                          if (bullets.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: bullets.map((line) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Container(
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color: ColorManager.primaryBlue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: SelectableText(
                                            line,
                                            style: AppTextStyles
                                                .nunito12w600overlayGray66
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge?.color,
                                                  fontSize: 16.sp,
                                                  height: 1.6,
                                                  letterSpacing: 0.2,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: SelectableText(
                                step.description,
                                style: AppTextStyles.nunito12w600overlayGray66
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                      fontSize: 16.sp,
                                      height: 1.6,
                                      letterSpacing: 0.2,
                                    ),
                              ),
                            ),

                          // Note (if different from description)
                          if (step.note.isNotEmpty &&
                              step.note != step.description) ...[
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: ColorManager.primaryBlue,
                                  size: 16,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: SelectableText(
                                    step.note,
                                    style: AppTextStyles
                                        .nunito12w600overlayGray66
                                        .copyWith(
                                          color: ColorManager.primaryBlue,
                                          fontSize: 15.sp,
                                          fontStyle: FontStyle.italic,
                                          height: 1.5,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          SizedBox(height: 16.h),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Navigation buttons ───────────────────────────────────────
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (currentStep > 0)
                    CustomButtonSmallTest(
                      text: 'previous'.tr(),
                      onTap: () {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),

                  const Spacer(),

                  CustomButtonSmallTest(
                    text: currentStep == total - 1 ? 'submit'.tr() : 'next'.tr(),
                    onTap: () async {
                      if (currentStep < total - 1) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await NotificationHelper.showNotification(
                          id: 1,
                          title: 'activity_completed'.tr(),
                          body:
                              'Great job completing ${widget.activity.title}!',
                        );

                        if (!context.mounted) return;

                        final bool? done = await Navigator.pushNamed<bool>(
                          context,
                          AppRoutes.activityDone,
                          arguments: {
                            'title': widget.activity.title,
                            'image': widget.activity.image,
                          },
                        );

                        if (done == true && context.mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}

