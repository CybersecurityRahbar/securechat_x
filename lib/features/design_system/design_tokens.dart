import 'package:flutter/material.dart';

final class SecureChatColors {
  const SecureChatColors._();

  static const Color canvas = Color(0xFF071018);
  static const Color surface = Color(0xFF0E1A24);
  static const Color surfaceRaised = Color(0xFF152532);
  static const Color surfaceInteractive = Color(0xFF1A2D3C);
  static const Color primary = Color(0xFF8BD8EE);
  static const Color primaryStrong = Color(0xFF5DB8D5);
  static const Color text = Color(0xFFEAF3F7);
  static const Color muted = Color(0xFF9FB3BF);
  static const Color subtle = Color(0xFF718793);
  static const Color divider = Color(0xFF263B49);
  static const Color success = Color(0xFF6DD7A3);
  static const Color warning = Color(0xFFF2BA65);
  static const Color danger = Color(0xFFF19A9A);
  static const Color neutral = Color(0xFF8FA4B0);
}

final class SecureChatSpace {
  const SecureChatSpace._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

final class SecureChatRadii {
  const SecureChatRadii._();

  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius control = BorderRadius.all(Radius.circular(12));
  static const BorderRadius card = BorderRadius.all(Radius.circular(18));
  static const BorderRadius panel = BorderRadius.all(Radius.circular(24));
}

final class SecureChatMotion {
  const SecureChatMotion._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration short = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration long = Duration(milliseconds: 360);
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
}

final class SecureChatIcons {
  const SecureChatIcons._();

  static const IconData home = Icons.grid_view_rounded;
  static const IconData chats = Icons.forum_outlined;
  static const IconData contacts = Icons.people_outline;
  static const IconData calls = Icons.call_outlined;
  static const IconData security = Icons.security_outlined;
  static const IconData settings = Icons.tune_outlined;
  static const IconData devices = Icons.devices_other_outlined;
  static const IconData activity = Icons.timeline_rounded;
  static const IconData transfer = Icons.swap_vert_rounded;
  static const IconData alert = Icons.shield_outlined;
  static const IconData search = Icons.search_rounded;
}

TextTheme _secureChatTextTheme() => const TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: SecureChatColors.text,
      ),
      headlineSmall: TextStyle(
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: SecureChatColors.text,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: SecureChatColors.text,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: SecureChatColors.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.45,
        color: SecureChatColors.text,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        color: SecureChatColors.muted,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.35,
        color: SecureChatColors.subtle,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: SecureChatColors.text,
      ),
    );

ThemeData secureChatTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: SecureChatColors.canvas,
    colorScheme: const ColorScheme.dark(
      primary: SecureChatColors.primary,
      onPrimary: SecureChatColors.canvas,
      primaryContainer: SecureChatColors.surfaceInteractive,
      onPrimaryContainer: SecureChatColors.text,
      secondary: SecureChatColors.primaryStrong,
      surface: SecureChatColors.surface,
      onSurface: SecureChatColors.text,
      surfaceContainerHighest: SecureChatColors.surfaceRaised,
      outline: SecureChatColors.divider,
      error: SecureChatColors.danger,
    ),
    dividerColor: SecureChatColors.divider,
    textTheme: _secureChatTextTheme(),
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: SecureChatColors.canvas,
      foregroundColor: SecureChatColors.text,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: SecureChatColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: SecureChatRadii.card),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: SecureChatColors.surface,
      indicatorColor: SecureChatColors.surfaceInteractive,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: SecureChatColors.surface,
      indicatorColor: SecureChatColors.surfaceInteractive,
      selectedIconTheme: IconThemeData(color: SecureChatColors.primary),
      unselectedIconTheme: IconThemeData(color: SecureChatColors.muted),
      selectedLabelTextStyle: TextStyle(color: SecureChatColors.text),
      unselectedLabelTextStyle: TextStyle(color: SecureChatColors.muted),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: SecureChatColors.surface,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: SecureChatRadii.control,
        borderSide: BorderSide(color: SecureChatColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: SecureChatRadii.control,
        borderSide: BorderSide(color: SecureChatColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: SecureChatRadii.control,
        borderSide: BorderSide(color: SecureChatColors.primaryStrong),
      ),
    ),
  );
}
