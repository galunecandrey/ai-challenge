import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

class AppTheme {
  static AppTheme? _theme;
  late ThemeData themeData;

  factory AppTheme.theme() => _theme ??= AppTheme._internal();

  AppTheme._internal() {
    final data = ThemeData.dark(useMaterial3: false);
    themeData = data.copyWith(
      brightness: Brightness.light,
      primaryColor: AppColors.visionableDarkBlue,
      colorScheme: data.colorScheme.copyWith(
        secondary: AppColors.white,
        surface: AppColors.lightGrayBackground,
      ),
      splashColor: Colors.transparent,
      scaffoldBackgroundColor: AppColors.lightGrayBackground,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(resolver),
        trackColor: WidgetStateProperty.resolveWith<Color?>(resolver),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(resolver),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(resolver),
      ),
      unselectedWidgetColor: AppColors.visionableDarkBlue,
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyles.styles().boldDarkBlue16,
        unselectedLabelStyle: TextStyles.styles().regularDarkBlue16,
        labelColor: AppColors.visionableDarkBlue,
        unselectedLabelColor: AppColors.visionableDarkBlue,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.visionableMidBlue,
            width: 2.0,
          ),
          insets: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.visionableLightBlue,
        inactiveTrackColor: AppColors.visionableLightBlue.withOpacity(0.15),
        thumbColor: AppColors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        trackHeight: 5,
        trackShape: const RoundedRectSliderTrackShape(),
        overlayShape: SliderComponentShape.noThumb,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyles.styles().lightWhite16.copyWith(fontSize: 96),
        displayMedium: TextStyles.styles().lightWhite16.copyWith(fontSize: 60),
        displaySmall: TextStyles.styles().regularWhite16.copyWith(fontSize: 48),
        headlineMedium: TextStyles.styles().regularWhite16.copyWith(fontSize: 34),
        headlineSmall: TextStyles.styles().regularWhite16.copyWith(fontSize: 24),
        titleLarge: TextStyles.styles().mediumWhite14.copyWith(fontSize: 20),
        titleMedium: TextStyles.styles().regularWhite16,
        titleSmall: TextStyles.styles().mediumWhite14,
        bodyLarge: TextStyles.styles().regularWhite16,
        bodyMedium: TextStyles.styles().regularWhite14,
        labelLarge: TextStyles.styles().mediumWhite14,
        bodySmall: TextStyles.styles().regularWhite12,
        labelSmall: TextStyles.styles().regularWhite12.copyWith(fontSize: 10),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.white,
        elevation: 0,
        titleTextStyle: TextStyles.styles().regularDarkBlue14,
        toolbarTextStyle: TextStyles.styles().regularDarkBlue14,
        actionsIconTheme: const IconThemeData(color: AppColors.visionableDarkBlue, opacity: 1, size: 24),
        iconTheme: const IconThemeData(color: AppColors.visionableDarkBlue),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.visionableBlue,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.visionableMidBlue,
        selectedLabelStyle: TextStyles.styles().regularWhite14,
        unselectedLabelStyle: TextStyles.styles().regularWhite14,
      ),
    );
  }
}

Color? resolver(Set<WidgetState> states) {
  if (states.contains(WidgetState.disabled)) {
    return null;
  }
  if (states.contains(WidgetState.selected)) {
    return AppColors.visionableLightBlue;
  }
  return null;
}
