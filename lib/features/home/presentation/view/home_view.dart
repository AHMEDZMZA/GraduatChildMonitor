import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_state.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
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
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeData(childId: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryBlue,
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: AppTextStyles.nunito14w400Grey,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.read<HomeCubit>().getHomeData(childId: null),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            String userName = 'Mam';
            String? childId;
            if (state is HomeSuccess) {
              userName = state.homeData.userName;
              // If childId was passed to getHomeData, use it. Otherwise use first child from list if available.
              childId = state.homeData.selectedChildId ?? (state.homeData.children.isNotEmpty ? state.homeData.children.first.id : null);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 10),

                  /// Header
                  HomeHeader(
                    userName: userName,
                    childId: childId,
                    onStatisticsTap: () {
                      if (childId != null) {
                        Navigator.pushNamed(context, AppRoutes.statistics, arguments: childId);
                      }
                    },
                  ),

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
                      Navigator.pushNamed(context, AppRoutes.todayPlan);
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
                      Navigator.pushNamed(context, AppRoutes.articles);
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
                      Navigator.pushNamed(context, AppRoutes.progressTracker);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
