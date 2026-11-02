/// Centralized spacing, radius and motion values.
///
/// Use these instead of inline literals so screens stay visually consistent.
class AppDimens {
  AppDimens._();

  // Spacing scale.
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  // Corner radii.
  static const double radiusInput = 12;
  // Buttons use a full pill radius so labels and icons share one consistent
  // rounded language throughout the app.
  static const double radiusButton = 999;
  static const double radiusCard = 18;
  static const double radiusSheet = 20;
  static const double radiusPill = 999;

  // Screen padding.
  static const double screenH = 16;
  static const double screenV = 16;

  // Icon sizes.
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
}

/// Animation durations. Kept short so the UI never feels like it is waiting.
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration cardEntrance = Duration(milliseconds: 480);
  static const int cardStaggerStepMs = 75;
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration shimmer = Duration(milliseconds: 1200);
}
