import 'package:flutter/material.dart';

import 'design_tokens.dart';

final class SecureChatMotionPreferences {
  const SecureChatMotionPreferences._();

  static bool reducedMotion(BuildContext context) =>
      MediaQuery.of(context).disableAnimations;

  static Duration duration(BuildContext context, Duration normal) =>
      reducedMotion(context) ? Duration.zero : normal;

  static Curve curve(BuildContext context, Curve normal) =>
      reducedMotion(context) ? Curves.linear : normal;
}

class SecureChatAnimatedSwitcher extends StatelessWidget {
  const SecureChatAnimatedSwitcher({
    required this.child,
    super.key,
    this.duration = SecureChatMotion.medium,
    this.switchInCurve = SecureChatMotion.standard,
    this.switchOutCurve = Curves.easeIn,
  });

  final Widget child;
  final Duration duration;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: SecureChatMotionPreferences.duration(context, duration),
    switchInCurve: SecureChatMotionPreferences.curve(context, switchInCurve),
    switchOutCurve: SecureChatMotionPreferences.curve(context, switchOutCurve),
    child: child,
  );
}
