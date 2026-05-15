import 'package:child_monitor_app/core/helpers/notification_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../data/activity_model.dart';
import '../../../../core/navigation/app_routes.dart';

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
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
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
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: ColorManager.lightGray,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorManager.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            step.image,
                            width: 261,
                            height: 191,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          step.title,
                          style: AppTextStyles.nunito30w900Black,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: 210,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.veryLightBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            step.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                              color: ColorManager.darkText,
                              fontSize: 16,
                              height: 1.45,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          step.note,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                            color: ColorManager.primaryBlue,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

