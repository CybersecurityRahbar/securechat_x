import 'package:flutter/material.dart';

final class SecureChatBreakpoints {
  const SecureChatBreakpoints._();

  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compact;

  static bool isMedium(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width >= compact && width < medium;
  }

  static bool isExpanded(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= medium;
}

final class SecureChatResponsiveInsets {
  const SecureChatResponsiveInsets._();

  static EdgeInsets page(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= SecureChatBreakpoints.expanded) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 32);
    }
    if (width >= SecureChatBreakpoints.medium) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 28);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
  }
}

final class SecureChatContentConstraints {
  const SecureChatContentConstraints._();

  static const double narrow = 760;
  static const double wide = 1120;
  static const double readable = wide;
}

class SecureChatConstrained extends StatelessWidget {
  const SecureChatConstrained({required this.child, super.key, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? SecureChatContentConstraints.readable,
      ),
      child: child,
    ),
  );
}
