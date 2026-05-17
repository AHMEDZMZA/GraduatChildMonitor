import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final String? childId;

  const EditChildProfileView({super.key, this.childId});

  @override
  State<EditChildProfileView> createState() => _EditChildProfileViewState();
}

class _EditChildProfileViewState extends State<EditChildProfileView> {
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController ageController =
      TextEditingController(); // Or birthDate depending on API
  final TextEditingController conditionController = TextEditingController();

  String? gender = 'Female';
  bool knowsCondition = false;
  final _formKey = GlobalKey<FormState>();

  bool get isEdit => widget.childId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      context.read<ProfileCubit>().getChildDetail(widget.childId!);
    }
  }

  @override
  void dispose() {
    childNameController.dispose();
    ageController.dispose();
    conditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ChildDetailLoaded) {
          childNameController.text = state.child.name;
          ageController.text = state.child.birthDate; // Simplify for now
          gender = state.child.gender;
          knowsCondition = state.child.knowsCondition;
          if (state.child.diagnosedCondition != null) {
            conditionController.text = state.child.diagnosedCondition!;
          }
          setState(() {});
        } else if (state is ChildAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child profile added successfully.'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          context.read<ProfileCubit>().getMyChildren(); // Refresh
          Navigator.pop(context);
        } else if (state is ChildUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child profile updated successfully.'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          context.read<ProfileCubit>().getMyChildren(); // Refresh
          Navigator.pop(context);
        } else if (state is ChildDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child profile deleted successfully.'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          context.read<ProfileCubit>().getMyChildren(); // Refresh
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.errorRed,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTopHeader(
                      title: isEdit
                          ? 'Edit Child Profile'
                          : 'Add Child Profile',
                    ),

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

                    const Text(
                      'Birth Date / Age',
                      style: AppTextStyles.nunito16w900Black,
                    ), // Label updated to indicate birth date is required
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'YYYY-MM-DD',
                      controller: ageController,
                      keyboardType: TextInputType.datetime,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Gender',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    const SizedBox(height: 4),

                    ProfileGenderSelector(
                      selectedGender: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Checkbox(
                          value: knowsCondition,
                          onChanged: (val) {
                            setState(() {
                              knowsCondition = val ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Knows Condition',
                          style: AppTextStyles.nunito16w900Black,
                        ),
                      ],
                    ),

                    if (knowsCondition) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Diagnosed Condition',
                        style: AppTextStyles.nunito16w900Black,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        isPassword: false,
                        hintText: 'Enter diagnosed condition',
                        controller: conditionController,
                      ),
                    ],

                    const SizedBox(height: 28),

                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is ProfileLoading
                              ? (isEdit ? 'Updating...' : 'Adding...')
                              : (isEdit ? 'Update Profile' : 'Add Profile'),
                          onTap: state is ProfileLoading
                              ? () {}
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (isEdit) {
                                      context.read<ProfileCubit>().updateChild(
                                        widget.childId!,
                                        name: childNameController.text.trim(),
                                        birthDate: ageController.text.trim(),
                                        gender: gender!.toUpperCase(),
                                        knowsCondition: knowsCondition,
                                        diagnosedCondition: knowsCondition
                                            ? conditionController.text.trim()
                                            : null,
                                      );
                                    } else {
                                      context.read<ProfileCubit>().addChild(
                                        name: childNameController.text.trim(),
                                        birthDate: ageController.text.trim(),
                                        gender: gender!.toUpperCase(),
                                        knowsCondition: knowsCondition,
                                        diagnosedCondition: knowsCondition
                                            ? conditionController.text.trim()
                                            : null,
                                      );
                                    }
                                  }
                                },
                        );
                      },
                    ),

                    if (isEdit) ...[
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
                                confirmText: 'Yes, Delete',
                                onConfirm: () {
                                  Navigator.pop(context); // Close bottom sheet
                                  context.read<ProfileCubit>().deleteChild(
                                    widget.childId!,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
