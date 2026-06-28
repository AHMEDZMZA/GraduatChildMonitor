import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/managers/theme_helper.dart';
import '../../../../core/widgets/animation_wrapper/animation_wrapper.dart';
import '../../../chat/presentation/view/chat_view.dart';
import '../../../home/presentation/view/home_view.dart';
import '../../../notification/presentation/view/notification_view.dart';
import '../../../profile/presentation/view/profile_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../notification/presentation/cubit/notification_cubit.dart';

class AppBottomNavBarView extends StatefulWidget {
  const AppBottomNavBarView({super.key});

  @override
  State<AppBottomNavBarView> createState() => _AppBottomNavBarViewState();
}

class _AppBottomNavBarViewState extends State<AppBottomNavBarView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    ChatView(),
    NotificationView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Force rebuild on locale change
    final _ = context.locale;
    
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AnimationWrapper(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 2) {
              context.read<NotificationCubit>().getNotifications();
            }
          },
          backgroundColor: context.cardBackground,
          selectedItemColor: ColorManager.primaryBlue,
          unselectedItemColor: ColorManager.mediumGray,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAssets.home),
              activeIcon: SvgPicture.asset(AppAssets.homeActive),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAssets.chat),
              activeIcon: SvgPicture.asset(AppAssets.chatActive),
              label: 'chat'.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAssets.notification),
              activeIcon: SvgPicture.asset(AppAssets.notificationActive),
              label: 'notification_setting'.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAssets.profile),
              activeIcon: SvgPicture.asset(AppAssets.profileActive),
              label: 'profile'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
