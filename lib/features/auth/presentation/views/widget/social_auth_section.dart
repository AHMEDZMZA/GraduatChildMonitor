import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/managers/app_text_styles.dart';
import '../../../../../core/managers/color_manager.dart';
import '../../cubit/auth_cubit.dart';
import 'custom_login_social.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// M-5: Extracted shared widget used by both [LoginView] and [SignupView].
///
/// Renders the social sign-in buttons (Google + Facebook) and the
/// "or sign in/up with" divider row. The [dividerLabel] param lets the
/// caller customise the label text ('or sign in with' vs 'or sign up with').
class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({super.key, required this.dividerLabel});

  final String dividerLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomLoginSocial(
          name: AppAssets.googleLogo,
          text: 'Sign in with Google',
          onTap: () => context.read<AuthCubit>().signInWithGoogle(),
        ),
        SizedBox(height: 10.h),
        CustomLoginSocial(
          name: AppAssets.facebookLogo,
          text: 'Sign in with Facebook',
          onTap: () => context.read<AuthCubit>().signInWithFacebook(),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          height: 36,
          child: Row(
            children: [
              const Expanded(
                child: Divider(
                  color: ColorManager.dividerSteel,
                  thickness: 1,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  dividerLabel,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.nunito14w400Grey,
                ),
              ),
              const Expanded(
                child: Divider(
                  color: ColorManager.dividerSteel,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 11.h),
      ],
    );
  }
}
