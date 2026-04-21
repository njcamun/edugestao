import 'package:flutter/widgets.dart';

class AdaptiveBreakpoints {
  static const double compact = 640;
  static const double medium = 720;
  static const double mobile = 900;
  static const double desktop = 1200;
  static const double wide = 1400;

  const AdaptiveBreakpoints._();
}

extension AdaptiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isCompact => screenWidth < AdaptiveBreakpoints.compact;

  bool get isMediumOrSmaller => screenWidth < AdaptiveBreakpoints.medium;

  bool get isMobile => screenWidth < AdaptiveBreakpoints.mobile;

  bool get isDesktop => screenWidth >= AdaptiveBreakpoints.desktop;

  bool get isWide => screenWidth >= AdaptiveBreakpoints.wide;

  double contentHorizontalPadding() {
    final width = screenWidth;
    if (width >= AdaptiveBreakpoints.wide) return 32;
    if (width >= 1000) return 24;
    if (width >= 700) return 16;
    return 12;
  }

  double contentVerticalPadding() {
    return screenWidth >= 1000 ? 16 : 12;
  }

  double maxContentWidth() {
    return screenWidth >= AdaptiveBreakpoints.desktop ? 1320 : double.infinity;
  }
}
