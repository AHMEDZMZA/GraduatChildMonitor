# Dark Mode Implementation Guide

## Overview
This app now has a complete dark mode implementation using `ThemeCubit` with `SharedPreferences` for persistence. The theming is managed through:

1. **ThemeCubit** - Manages the theme state (light/dark/system)
2. **AppTheme** - Defines complete light and dark themes
3. **ThemeHelper** - Provides easy access to theme-aware colors

## Files Added/Modified

### Core Theme Files
- `lib/core/managers/theme_cubit.dart` - Hydrated theme state management
- `lib/core/managers/app_theme.dart` - Theme definitions for light and dark modes
- `lib/core/managers/theme_helper.dart` - BuildContext extensions for theme-aware colors
- `lib/core/widgets/theme_switch.dart` - Standalone theme toggle widget
- `lib/features/profile/presentation/widgets/theme_toggle_item.dart` - Integrated theme toggle in settings

### Updated Files
- `lib/main.dart` - Theme initialization and configuration
- `lib/core/di/service_locator.dart` - ThemeCubit registration
- `lib/pubspec.yaml` - Dependencies updated

## How to Use Theme-Aware Colors

### Method 1: Using BuildContext Extensions (Recommended)
The easiest way to get theme-aware colors anywhere in your widgets:

```dart
import 'package:child_monitor_app/core/managers/theme_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.scaffoldBackground,  // Automatically light/dark
      child: Text(
        'Hello World',
        style: TextStyle(color: context.textColor),  // Auto theme-aware
      ),
    );
  }
}
```

### Available BuildContext Extensions:
- `context.isDarkMode` - Boolean to check if dark mode is active
- `context.scaffoldBackground` - Scaffold background color
- `context.cardBackground` - Card/elevated surface color
- `context.textColor` - Primary text color
- `context.secondaryTextColor` - Secondary/muted text color
- `context.borderColor` - Border and divider color
- `context.dividerColor` - Divider/line color
- `context.inputFillColor` - Text field fill color
- `context.inputBorderColor` - Text field border color
- `context.disabledColor` - Disabled state color

### Method 2: Using ThemeHelper Class
```dart
import 'package:child_monitor_app/core/managers/theme_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bgColor = ThemeHelper.getBackgroundColor(context);
    final isDark = ThemeHelper.isDarkMode(context);
    
    return Container(color: bgColor);
  }
}
```

## Refactoring Existing Views

### Step 1: Import Theme Helper
```dart
import '../../../../core/managers/theme_helper.dart';
```

### Step 2: Replace Hardcoded Colors
**Before:**
```dart
Container(
  backgroundColor: Colors.white,
  child: Text(
    'Title',
    style: TextStyle(color: Colors.black),
  ),
)
```

**After:**
```dart
Container(
  backgroundColor: context.cardBackground,
  child: Text(
    'Title',
    style: TextStyle(color: context.textColor),
  ),
)
```

### Step 3: For Placeholder/Loading Colors
```dart
// Instead of Colors.grey[300] or Colors.grey[400]
final placeholderColor = context.isDarkMode ? const Color(0xFF333333) : Colors.grey[300];
```

## Theme Color Palette

### Light Mode
- Background: `#FAFAFA` (off-white)
- Card/Surface: `#FFFFFF` (white)
- Text: `#212121` (dark text)
- Borders: `#E2E5EA` (light gray)

### Dark Mode
- Background: `#222222` (near black)
- Card/Surface: `#1E1E1E` (dark gray)
- Text: `#FFFFFF` (white)
- Borders: `#333333` (dark gray)

### Primary Color (Both Modes)
- Primary: `#2563EB` (blue)

## Best Practices

1. **Always use theme-aware colors** - Avoid hardcoding colors
2. **Use AppTextStyles** - Text styles are already theme-aware
3. **Test in both modes** - Toggle dark mode frequently during development
4. **Leverage Material 3** - Use ThemeData properties like:
   - `Theme.of(context).colorScheme`
   - `Theme.of(context).textTheme`
5. **For gradients** - Consider darkening images in dark mode or using different gradient colors

## Testing Dark Mode

### Manual Toggle
1. Open app Settings (Profile tab → Settings)
2. Toggle the "Dark Mode" switch
3. Change is persisted and survives app restart

### Programmatic Toggle
```dart
context.read<ThemeCubit>().toggleTheme();
// or set specific mode
context.read<ThemeCubit>().setTheme(ThemeMode.dark);
```

## Common Patterns

### Safe Color Adaptation
```dart
final Color bgColor = context.isDarkMode 
  ? const Color(0xFF1E1E1E) 
  : ColorManager.backgroundLight;
```

### Icon Colors
```dart
Icon(Icons.star, color: ColorManager.primaryBlue) // Primary blue works in both modes
```

### Dialog Backgrounds
```dart
showDialog(
  context: context,
  builder: (context) => Dialog(
    backgroundColor: context.cardBackground,
    child: Text('Hello', style: TextStyle(color: context.textColor)),
  ),
);
```

## Files Ready for Refactoring

These views would benefit from theme-aware color updates:
- `lib/features/today_plan/presentation/views/*.dart`
- `lib/features/articles/presentation/view/*.dart`
- `lib/features/notification/presentation/view/*.dart`
- `lib/features/progress/presentation/view/*.dart`
- `lib/features/home/presentation/view/*.dart`

## Troubleshooting

### Colors not changing in dark mode?
1. Make sure you're using `context.xxxColor` instead of hardcoded colors
2. Check that the view is wrapped by `BlocBuilder` or `BlocListener` for theme changes
3. Use `Theme.of(context).brightness == Brightness.dark` to verify dark mode

### New widgets not getting theme?
1. Ensure `AppTheme.lightTheme()` and `AppTheme.darkTheme()` are applied in MaterialApp
2. Verify `ThemeCubit` is registered in service locator
3. Check that `BlocBuilder<ThemeCubit, ThemeMode>` wraps the MaterialApp

## Next Steps

1. Review all view files and replace hardcoded colors with theme helpers
2. Test each view in both light and dark modes
3. Update custom widgets to support theme transitions
4. Consider adding theme selection to settings (light/dark/system)
