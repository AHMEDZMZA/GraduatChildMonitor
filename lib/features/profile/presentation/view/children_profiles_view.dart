import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/service_locator.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/child_profile_item.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildrenProfilesView extends StatefulWidget {
  const ChildrenProfilesView({super.key});

  @override
  State<ChildrenProfilesView> createState() => _ChildrenProfilesViewState();
}

class _ChildrenProfilesViewState extends State<ChildrenProfilesView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getMyChildren();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ChildDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child profile deleted.'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          context.read<ProfileCubit>().getMyChildren();
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.errorRed,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),

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
                          color: ColorManager.darkText,
                        ),
                      ),
                    ),
                    SizedBox(width: 50.w),
                    CustomText(
                      text: 'Children Profiles',
                      style: AppTextStyles.nunito30w900Black.copyWith(
                        color: ColorManager.primaryBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 34.h),

                Expanded(
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primaryBlue,
                          ),
                        );
                      }

                      if (state is ProfileError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: ColorManager.errorRed,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                state.message,
                                style: AppTextStyles.nunito14w400Grey,
                              ),
                              SizedBox(height: 16.h),
                              TextButton(
                                onPressed: () => context
                                    .read<ProfileCubit>()
                                    .getMyChildren(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is ChildrenLoaded) {
                        if (state.children.isEmpty) {
                          return Center(
                            child: Text(
                              'No children profiles yet.',
                              style: AppTextStyles.nunito14w400Grey,
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: state.children.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: 14.h),
                          itemBuilder: (context, index) {
                            final child = state.children[index];
                            return ChildProfileItem(
                              name: child.name,
                              onEdit: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editChildProfile,
                                  arguments: child.id,
                                );
                              },
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  builder: (_) {
                                    return AppBottomSheet(
                                      title: 'Switch Child Profile',
                                      description:
                                          'Are you sure you want to switch to ${child.name}\'s profile?',
                                      confirmText: 'Yes, Switch',
                                      onConfirm: () {
                                        Navigator.pop(context);
                                        // Save to local storage
                                        getIt<SharedPreferences>().setString(
                                          'childId',
                                          child.id.toString(),
                                        );
                                        // Refresh home data
                                        context.read<HomeCubit>().getHomeData(
                                          childId: child.id.toString(),
                                        );
                                        // Feedback SnackBar
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Switched active profile to ${child.name}.',
                                            ),
                                            backgroundColor:
                                                ColorManager.brightTeal,
                                          ),
                                        );
                                        // Return to the main screen
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                CustomButton(
                  text: 'Add Child Profile',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.addChildProfile);
                  },
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
