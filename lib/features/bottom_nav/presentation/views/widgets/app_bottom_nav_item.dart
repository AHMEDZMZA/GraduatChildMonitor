// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../../core/constants/app_assets.dart';
// import '../../../../../core/managers/color_manager.dart';
// import '../../manager/bottom_nav_cubit.dart';
//
// class AppBottomNavBar extends StatelessWidget {
//   const AppBottomNavBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final BottomNavCubit cubit = context.watch<BottomNavCubit>();
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: cubit.appNavIndex,
//       onTap: cubit.changeNavIndex,
//       backgroundColor: ColorManager.white,
//       elevation: 8,
//       items: [
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset(AppAssets.chat),
//           activeIcon: SvgPicture.asset(AppAssets.chatActive),
//           label: 'Chat',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset(AppAssets.home),
//           activeIcon: SvgPicture.asset(AppAssets.homeActive),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset(AppAssets.notification),
//           activeIcon: SvgPicture.asset(AppAssets.notificationActive),
//           label: 'Notification',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset(AppAssets.profile),
//           activeIcon: SvgPicture.asset(AppAssets.profileActive),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
