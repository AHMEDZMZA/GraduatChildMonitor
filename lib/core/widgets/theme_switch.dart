import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../managers/theme_cubit.dart';

class ThemeSwitch extends StatelessWidget {
  final String title;
  const ThemeSwitch({super.key, this.title = 'Dark Mode'});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        return SwitchListTile(
          title: Text(title),
          value: isDark,
          onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}
