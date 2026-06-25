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
import '../../../profile/domain/entities/profile_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final prefs = getIt<SharedPreferences>();
    final savedChildId = prefs.getString('childId');
    context.read<HomeCubit>().getHomeData(childId: savedChildId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeSuccess) {
              final childId = state.homeData.selectedChildId ??
                  (state.homeData.children.isNotEmpty
                      ? state.homeData.children.first.id
                      : null);
              if (childId != null) {
                getIt<SharedPreferences>().setString('childId', childId);
              }
            }
          },
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
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    SizedBox(height: 12.h),
                    Text(state.message, style: AppTextStyles.nunito14w400Grey),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        final prefs = getIt<SharedPreferences>();
                        final savedChildId = prefs.getString('childId');
                        context.read<HomeCubit>().getHomeData(childId: savedChildId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView(
                children: [
                  SizedBox(height: 10.h),
                  _HomeHeaderSection(),
                  SizedBox(height: 20.h),
                  const HomeBanner(),
                  SizedBox(height: 24.h),
                  _CardsSection(selectedIndex: selectedIndex, onCardTap: (index) {
                    setState(() => selectedIndex = index);
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is HomeSuccess,
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();
        final childId = state.homeData.selectedChildId ??
            (state.homeData.children.isNotEmpty
                ? state.homeData.children.first.id
                : null);
        return HomeHeader(
          userName: state.homeData.userName,
          childId: childId,
          onStatisticsTap: () {
            if (childId != null) {
              Navigator.pushNamed(
                context,
                AppRoutes.statistics,
                arguments: childId,
              );
            }
          },
        );
      },
    );
  }
}

class _CardsSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCardTap;

  const _CardsSection({required this.selectedIndex, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is HomeSuccess,
      builder: (context, state) {
        ChildProfileEntity? selectedChild;
        if (state is HomeSuccess) {
          final childId = state.homeData.selectedChildId ??
              (state.homeData.children.isNotEmpty
                  ? state.homeData.children.first.id
                  : null);
          if (childId != null && state.homeData.children.isNotEmpty) {
            selectedChild = state.homeData.children.firstWhere(
              (c) => c.id == childId,
              orElse: () => state.homeData.children.first,
            );
          }
        }

        return Column(
          children: [
            HomeCard(
              title: "Today's Plan for Your Child",
              subtitle: "Simple activities tailored to your child's needs today.",
              image: AppAssets.cardHome1,
              isSelected: selectedIndex == 0,
              onTap: () {
                onCardTap(0);
                Navigator.pushNamed(context, AppRoutes.todayPlan);
              },
            ),
            SizedBox(height: 16.h),
            HomeCard(
              title: 'Parent Articles',
              subtitle: "Easy-to-read articles to help you understand your child's condition and support them effectively",
              image: AppAssets.cardHome2,
              isSelected: selectedIndex == 1,
              onTap: () {
                onCardTap(1);
                Navigator.pushNamed(context, AppRoutes.articles);
              },
            ),
            SizedBox(height: 16.h),
            HomeCard(
              title: 'Track Your Child’s Progress',
              subtitle: "Monitor your child's improvement each month based on your observations",
              image: AppAssets.cardHome3,
              isSelected: selectedIndex == 2,
              onTap: () {
                onCardTap(2);
                if (selectedChild != null) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.progressTracker,
                    arguments: selectedChild,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
