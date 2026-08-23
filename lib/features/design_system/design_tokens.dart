import 'package:flutter/material.dart';

final class SecureChatColors {
  const SecureChatColors._();
  static const Color canvas = Color(0xFF0A111A);
  static const Color surface = Color(0xFF121F2B);
  static const Color surfaceRaised = Color(0xFF192A39);
  static const Color primary = Color(0xFF82D0E9);
  static const Color text = Color(0xFFE9F1F5);
  static const Color muted = Color(0xFF9DB0BC);
  static const Color warning = Color(0xFFF2BA65);
  static const Color danger = Color(0xFFF19A9A);
  static const Color neutral = Color(0xFF8FA4B0);
}

final class SecureChatSpace {
  const SecureChatSpace._();
  static const double xs = 4, sm = 8, md = 16, lg = 24, xl = 32;
}

final class SecureChatRadii {
  const SecureChatRadii._();
  static const BorderRadius card = BorderRadius.all(Radius.circular(16));
  static const BorderRadius control = BorderRadius.all(Radius.circular(12));
}

final class SecureChatMotion {
  const SecureChatMotion._();
  static const Duration short = Duration(milliseconds: 160);
  static const Curve standard = Curves.easeOutCubic;
}

final class SecureChatIcons {
  const SecureChatIcons._();
  static const IconData home = Icons.grid_view_rounded;
  static const IconData chats = Icons.forum_outlined;
  static const IconData contacts = Icons.people_outline;
  static const IconData calls = Icons.call_outlined;
  static const IconData security = Icons.security_outlined;
  static const IconData settings = Icons.tune_outlined;
}

ThemeData secureChatTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SecureChatColors.canvas,
      colorScheme: const ColorScheme.dark(
        primary: SecureChatColors.primary,
        surface: SecureChatColors.surface,
        onSurface: SecureChatColors.text,
        error: SecureChatColors.danger,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: SecureChatColors.text),
        titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: SecureChatColors.text),
        bodyMedium:
            TextStyle(fontSize: 14, height: 1.4, color: SecureChatColors.muted),
      ),
      cardTheme: const CardThemeData(
          color: SecureChatColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: SecureChatRadii.card)),
      inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: SecureChatRadii.control)),
    );
