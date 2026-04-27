import 'package:child_monitor_app/features/home/presentation/view/progress_tracker_view.dart';
import 'package:flutter/material.dart';
import '../../../../../core/managers/color_manager.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../articles/presentation/view/articles_view.dart';
import '../../../today_plan/presentation/views/today_view.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_card.dart';
import '../widgets/home_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 10),

              /// Header
              const HomeHeader(),

              const SizedBox(height: 20),

              /// Banner
              const HomeBanner(),

              const SizedBox(height: 24),

              /// Cards
              HomeCard(
                title: "Today's Plan for Your Child",
                subtitle:
                    "Simple activities tailored to your child's needs today.",
                image: AppAssets.cardHome1,
                isSelected: selectedIndex == 0,
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TodayView()),
                  );
                },
              ),
              const SizedBox(height: 16),

              HomeCard(
                title: 'Parent Articles',
                subtitle:
                    "Easy-to-read articles to help you understand your child's condition and support them effectively",
                image: AppAssets.cardHome2,
                isSelected: selectedIndex == 1,
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArticlesView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              HomeCard(
                title: 'Track Your Child’s Progress',
                subtitle:
                    "Monitor your child's improvement each month based on your observations",
                image: AppAssets.cardHome3,
                isSelected: selectedIndex == 2,
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgressTrackerView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
