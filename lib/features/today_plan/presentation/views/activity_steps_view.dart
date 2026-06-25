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

  const ActivityStepsView({
    super.key,
    required this.activity,
  });

  @override
  State<ActivityStepsView> createState() => _ActivityStepsViewState();
}

class _ActivityStepsViewState extends State<ActivityStepsView> {
  final PageController controller = PageController();
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final total = widget.activity.steps.length;
    final progress = (currentStep + 1) / total;

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
              SizedBox(height: 16.h),
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
              SizedBox(height: 20.h),
              SizedBox(
                height: 500,
                child: PageView.builder(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.activity.steps.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentStep = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final step = widget.activity.steps[index];
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Step ${currentStep + 1} of $total',
                            style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(
                            step.image,
                            width: 261,
                            height: 191,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          step.title,
                          style: AppTextStyles.nunito30w900Black,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 18.h),
                        Container(
                          width: 210,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            step.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 16.sp,
                              height: 1.45,
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          step.note,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                            color: ColorManager.primaryBlue,
                            fontSize: 16.sp,
                            height: 1.4,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (currentStep > 0)
                    CustomButtonSmallTest(
                      text: 'Previous',
                      onTap: () {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),

                  const Spacer(),

                  CustomButtonSmallTest(
                    text: currentStep == total - 1 ? 'Submit' : 'Next',
                    onTap: () async {
                      if (currentStep < total - 1) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await NotificationHelper.showNotification(
                          id: 1,
                          title: 'Activity Completed!',
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
                      }
                    },
                  ),
                  // CustomButtonSmallTest(
                  //   text: currentStep == total - 1 ? 'Submit' : 'Next',
                  //   onTap: () {
                  //     if (currentStep < total - 1) {
                  //       controller.nextPage(
                  //         duration: const Duration(milliseconds: 250),
                  //         curve: Curves.easeInOut,
                  //       );
                  //     } else {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => ActivityDoneView(
                  //             title: widget.activity.title,
                  //             image: widget.activity.image,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
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

