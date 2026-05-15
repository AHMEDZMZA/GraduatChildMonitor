import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_top_header.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserProfile();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UserProfileLoaded) {
          fullNameController.text = state.profile.monitorName;
          emailController.text = state.profile.email;
        } else if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: ColorManager.backgroundWhite,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileTopHeader(title: 'Profile'),
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

                    const SizedBox(height: 30),

                    const Text(
                      'Full Name',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'Enter full name',
                      controller: fullNameController,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 18),

                    const Text('Email', style: AppTextStyles.nunito16w900Black),
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'Enter email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 80),

                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is ProfileLoading
                              ? 'Updating...'
                              : 'Update Profile',
                          onTap: state is ProfileLoading
                              ? () {}
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ProfileCubit>().updateUserProfile(
                                          fullNameController.text.trim(),
                                          emailController.text.trim(),
                                        );
                                  }
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
      ),
    );
  }
}
