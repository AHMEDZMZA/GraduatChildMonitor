import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../bottom_nav/presentation/views/app_bottom_nav_view.dart';
import '../../data/model.dart';
import '../widgets/progress_item.dart';
import 'monthly_progress_details_view.dart';

class MonthlyProgressView extends StatefulWidget {
  const MonthlyProgressView({super.key});

  @override
  State<MonthlyProgressView> createState() => _MonthlyProgressViewState();
}

class _MonthlyProgressViewState extends State<MonthlyProgressView> {
  int selectedIndex = 1;

  final List<MonthlyProgressModel> list = const [
    MonthlyProgressModel(
      id: 1,
      month: 'JAN',
      title: 'Great progress today!',
      date: '08 January 2024 | 03:23 AM',
    ),
    MonthlyProgressModel(
      id: 2,
      month: 'FEB',
      title: 'Great progress today!',
      date: '08 February 2024 | 03:23 AM',
    ),
    MonthlyProgressModel(
      id: 3,
      month: 'MAR',
      title: 'Great progress today!',
      date: '08 March 2024 | 03:23 AM',
    ),
    MonthlyProgressModel(
      id: 4,
      month: 'APR',
      title: 'Great progress today!',
      date: '08 April 2024 | 03:23 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = list.isEmpty;

    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AppBottomNavBarView(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: ColorManager.buttonBlue,
                    radius: 18,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: CustomText(
                  text: 'Your Child’s Monthly Assessments',
                  style: AppTextStyles.nunito30w900Black,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 6),

              const Center(
                child: CustomText(
                  text: 'Review your child’s monthly progress here.',
                  style: AppTextStyles.nunito14w400Grey,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: isEmpty
                    ? const Center(child: _EmptyState())
                    : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];

                    return ProgressItem(
                      item: item,
                      highlighted: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MonthlyProgressDetailsView(item: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 240,
      decoration: BoxDecoration(
        color: ColorManager.veryLightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.primaryBlue),
      ),
      alignment: Alignment.center,
      child: const CustomText(
        text: 'No monthly assessment yet',
        style: AppTextStyles.nunito16w900Green,
      ),
    );
  }
}