import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_top_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      if (mounted) {
        context.read<ProfileCubit>().uploadProfileImage(_selectedImage!);
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
              backgroundColor: ColorManager.brightTeal,
            ),
          );
        } else if (state is ProfileImageUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image uploaded successfully!'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
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
                    const ProfileTopHeader(title: 'Profile'),
                    SizedBox(height: 34.h),

                    Center(
                      child: GestureDetector(
                        onTap: _showImagePickerOptions,
                        child: ProfileAvatarSection(
                          imagePath: AppAssets.profileProfile,
                          userName: '',
                          imageFile: _selectedImage,
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    Text(
                      'Full Name',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'Enter full name',
                      controller: fullNameController,
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: 18.h),

                    Text('Email', style: AppTextStyles.nunito16w900Black),
                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'Enter email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 80.h),

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
                                    context
                                        .read<ProfileCubit>()
                                        .updateUserProfile(
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
