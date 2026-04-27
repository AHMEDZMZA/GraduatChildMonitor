import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/child_profile_item.dart';
import 'edit_child_profile_view.dart';

class ChildrenProfilesView extends StatelessWidget {
  const ChildrenProfilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 16),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: ColorManager.buttonBlue,
                      radius: 20,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  CustomText(
                    text: 'Children Profiles',
                    style: AppTextStyles.nunito30w900Black.copyWith(
                      color: ColorManager.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),

              ChildProfileItem(name: 'Child1', onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  builder: (_) {
                    return AppBottomSheet(
                      title: 'Switch Child Profile',
                      description:
                      'Are you sure you want to switch Child Profile?',
                      confirmText: 'Yes,Switch',
                      onConfirm: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditChildProfileView()),
                        );
                      },
                    );
                  },
                );
              }
              ),

              const SizedBox(height: 14),

              ChildProfileItem(name: 'Child2', onTap: () {}),

              const Spacer(),

              CustomButton(
                text: 'Add Child Profile',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const AddChildDataView()),
                  // );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
