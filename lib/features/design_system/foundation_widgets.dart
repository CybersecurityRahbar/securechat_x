import 'package:flutter/material.dart';

import 'design_tokens.dart';

class SecureChatButton extends StatelessWidget {
  const SecureChatButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: onPressed,
        icon: icon ?? const SizedBox.shrink(),
        label: Text(label),
      );
}

class SecureChatIconButton extends StatelessWidget {
  const SecureChatIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon),
        tooltip: label,
        onPressed: onPressed,
      );
}

class SecureChatCard extends StatelessWidget {
  const SecureChatCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(SecureChatSpace.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: padding,
          child: child,
        ),
      );
}

class SecureChatSurface extends StatelessWidget {
  const SecureChatSurface({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(SecureChatSpace.md),
    this.color,
    this.borderRadius = SecureChatRadii.card,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? SecureChatColors.surface,
          borderRadius: borderRadius,
          border: Border.all(color: SecureChatColors.divider),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      );
}

class SecureChatTextField extends StatelessWidget {
  const SecureChatTextField({
    required this.label,
    super.key,
    this.controller,
    this.enabled = true,
    this.hintText,
    this.prefixIcon,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool enabled;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        ),
      );
}

class SecureChatSectionHeader extends StatelessWidget {
  const SecureChatSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: SecureChatSpace.xs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class SecureChatMetric extends StatelessWidget {
  const SecureChatMetric({
    required this.label,
    required this.value,
    super.key,
    this.icon,
    this.accentColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: accentColor ?? SecureChatColors.primary,
              size: 20,
            ),
            const SizedBox(width: SecureChatSpace.sm),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: SecureChatSpace.xxs),
              Text(value, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ],
      );
}

class SecureChatStatusPill extends StatelessWidget {
  const SecureChatStatusPill({
    required this.label,
    super.key,
    this.color = SecureChatColors.neutral,
    this.icon = Icons.circle,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SecureChatSpace.sm,
          vertical: SecureChatSpace.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: const BorderRadius.all(Radius.circular(999)),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: SecureChatSpace.xs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}

Future<T?> showSecureChatDialog<T>(
  BuildContext context, {
  required Widget child,
}) => showDialog<T>(
      context: context,
      builder: (_) => AlertDialog(content: child),
    );

Future<T?> showSecureChatBottomSheet<T>(
  BuildContext context, {
  required Widget child,
}) => showModalBottomSheet<T>(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SecureChatSpace.md),
          child: child,
        ),
      ),
    );

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: 'Loading',
          child: const CircularProgressIndicator(),
        ),
      );
}

class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(message, textAlign: TextAlign.center),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: SecureChatSpace.sm),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      );
}

enum SecurityStatus { notImplemented, needsAttention, established }

class SecurityStatusIndicator extends StatelessWidget {
  const SecurityStatusIndicator({required this.status, super.key});

  final SecurityStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color, String) value = switch (status) {
      SecurityStatus.notImplemented => (
          SecureChatColors.neutral,
          'Not implemented',
        ),
      SecurityStatus.needsAttention => (
          SecureChatColors.warning,
          'Needs attention',
        ),
      SecurityStatus.established => (
          SecureChatColors.success,
          'Established',
        ),
    };
    return SecureChatStatusPill(
      label: value.$2,
      color: value.$1,
      icon: Icons.circle,
    );
  }
}
