import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/service_locator.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_gender_selector.dart';
import '../widgets/profile_top_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          // Reload Home data for the newly added child
          context.read<HomeCubit>().getHomeData(childId: state.childId.toString());
          Navigator.pop(context);
        } else if (state is ChildUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child profile updated successfully.'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          context.read<ProfileCubit>().getMyChildren(); // Refresh
          // Reload Home data using the current active childId in case it was updated
          final activeChildId = getIt<SharedPreferences>().getString('childId');
          context.read<HomeCubit>().getHomeData(childId: activeChildId);
          Navigator.pop(context);
        } else if (state is ChildDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child profile deleted successfully.'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          context.read<ProfileCubit>().getMyChildren(); // Refresh
          // Clear active childId from prefs if the active child was deleted
          final activeChildId = getIt<SharedPreferences>().getString('childId');
          if (activeChildId == widget.childId) {
            getIt<SharedPreferences>().remove('childId');
          }
          final newActiveChildId = getIt<SharedPreferences>().getString('childId');
          context.read<HomeCubit>().getHomeData(childId: newActiveChildId);
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
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTopHeader(
                      title: isEdit
                          ? 'Edit Child Profile'
                          : 'Add Child Profile',
                    ),

                    SizedBox(height: 34.h),

                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: const ProfileAvatarSection(
                          imagePath: AppAssets.profileProfile,
                          userName: '',
                        ),
                      ),
                    ),

                    SizedBox(height: 26.h),

                    Text(
                      'Child Name',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'Enter child name',
                      controller: childNameController,
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      'Birth Date / Age',
                      style: AppTextStyles.nunito16w900Black,
                    ), // Label updated to indicate birth date is required
                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'YYYY-MM-DD',
                      controller: ageController,
                      keyboardType: TextInputType.datetime,
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      'Gender',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 4.h),

                    ProfileGenderSelector(
                      selectedGender: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),

                    SizedBox(height: 18.h),

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
                        Text(
                          'Knows Condition',
                          style: AppTextStyles.nunito16w900Black,
                        ),
                      ],
                    ),

                    if (knowsCondition) ...[
                      SizedBox(height: 10.h),
                      Text(
                        'Diagnosed Condition',
                        style: AppTextStyles.nunito16w900Black,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        isPassword: false,
                        hintText: 'Enter diagnosed condition',
                        controller: conditionController,
                      ),
                    ],

                    SizedBox(height: 28.h),

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
                      SizedBox(height: 14.h),

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
