import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../data/activity_model.dart';
import '../../../../core/navigation/app_routes.dart';

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
      setState(() {
        isCompleted = true;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, isCompleted),
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
              const SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  widget.activity.image,
                  width: 261,
                  height: 191,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.activity.title,
                style: AppTextStyles.nunito30w900Black,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Activity Info',
                style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.circle, text: widget.activity.duration),
              const SizedBox(height: 4),
              _InfoRow(icon: Icons.circle, text: widget.activity.difficulty),
              const SizedBox(height: 4),
              _InfoRow(icon: Icons.circle, text: widget.activity.suitableAge),
              if (isCompleted) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 90),

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
              const SizedBox(height: 14),
            ],
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
        Icon(icon, size: 6, color: ColorManager.black),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.nunito12w600overlayGray66.copyWith(
            color: ColorManager.darkText,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
