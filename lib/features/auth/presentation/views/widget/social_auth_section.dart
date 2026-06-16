import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/managers/app_text_styles.dart';
import '../../../../../core/managers/color_manager.dart';
import '../../cubit/auth_cubit.dart';
import 'custom_login_social.dart';

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
        const SizedBox(height: 10),
        CustomLoginSocial(
          name: AppAssets.facebookLogo,
          text: 'Sign in with Facebook',
          onTap: () => context.read<AuthCubit>().signInWithFacebook(),
        ),
        const SizedBox(height: 20),
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
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
        const SizedBox(height: 11),
      ],
    );
  }
}
