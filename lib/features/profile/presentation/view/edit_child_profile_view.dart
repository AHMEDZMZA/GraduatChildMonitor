import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_gender_selector.dart';
import '../widgets/profile_top_header.dart';

class EditChildProfileView extends StatefulWidget {
  const EditChildProfileView({super.key});

  @override
  State<EditChildProfileView> createState() => _EditChildProfileViewState();
}

class _EditChildProfileViewState extends State<EditChildProfileView> {
  final TextEditingController childNameController = TextEditingController(
    text: '&&&&&',
  );

  final TextEditingController ageController = TextEditingController(text: '&&');

  String? gender = 'Female';

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    childNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.backgroundWhite,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileTopHeader(title: 'Child Profile'),

                  const SizedBox(height: 34),

                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: const ProfileAvatarSection(
                        imagePath: AppAssets.profileProfile,
                        userName: '',
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  const Text(
                    'Child Name',
                    style: AppTextStyles.nunito16w900Black,
                  ),
                  const SizedBox(height: 10),

                  CustomTextFormField(
                    isPassword: false,
                    hintText: 'Enter child name',
                    controller: childNameController,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 18),

                  const Text('Age', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 10),

                  CustomTextFormField(
                    isPassword: false,
                    hintText: 'Enter child age',
                    controller: ageController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  const Text('Gender', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 4),

                  ProfileGenderSelector(
                    selectedGender: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  CustomButton(
                    text: 'Update Profile',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // update child profile logic
                      }
                    },
                  ),

                  const SizedBox(height: 14),

                  CustomButton(
                    text: 'Delete Profile',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        builder: (_) {
                          return AppBottomSheet(
                            title: 'Delete Child Profile',
                            description:
                                'Are you sure you want to delete Child Profile?',
                            confirmText: 'Yes,Delete',
                            onConfirm: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
