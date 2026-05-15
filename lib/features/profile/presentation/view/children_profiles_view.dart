import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/child_profile_item.dart';
import '../../../../core/navigation/app_routes.dart';

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
              backgroundColor: Colors.green,
            ),
          );
          context.read<ProfileCubit>().getMyChildren();
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
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
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(
                                state.message,
                                style: AppTextStyles.nunito14w400Grey,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () =>
                                    context.read<ProfileCubit>().getMyChildren(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is ChildrenLoaded) {
                        if (state.children.isEmpty) {
                          return const Center(
                            child: Text(
                              'No children profiles yet.',
                              style: AppTextStyles.nunito14w400Grey,
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: state.children.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final child = state.children[index];
                            return ChildProfileItem(
                              name: child.name,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  builder: (_) {
                                    return AppBottomSheet(
                                      title: 'Switch Child Profile',
                                      description:
                                          'Are you sure you want to switch Child Profile?',
                                      confirmText: 'Yes, Switch',
                                      onConfirm: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.editChildProfile,
                                          arguments: child.id,
                                        );
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
                    Navigator.pushNamed(context, AppRoutes.editChildProfile);
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
