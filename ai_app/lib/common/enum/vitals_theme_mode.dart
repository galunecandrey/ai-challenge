enum VitalsThemeMode {
  light,
  dark,
  mixedDarkLight,
}

extension ResolveThemeModeExtension on VitalsThemeMode {
  T resolve<T>({
    required T light,
    required T dark,
    T? mixedDarkLight,
  }) {
    switch (this) {
      case VitalsThemeMode.light:
        return light;
      case VitalsThemeMode.dark:
        return dark;
      case VitalsThemeMode.mixedDarkLight:
        return mixedDarkLight ?? light;
    }
  }
}
