import 'package:flutter/material.dart';

import 'design_tokens.dart';

class SecureChatButton extends StatelessWidget {
  const SecureChatButton(
      {required this.label, required this.onPressed, super.key});
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) =>
      FilledButton(onPressed: onPressed, child: Text(label));
}

class SecureChatIconButton extends StatelessWidget {
  const SecureChatIconButton(
      {required this.icon,
      required this.label,
      required this.onPressed,
      super.key});
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) =>
      IconButton(icon: Icon(icon), tooltip: label, onPressed: onPressed);
}

class SecureChatCard extends StatelessWidget {
  const SecureChatCard({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
          padding: const EdgeInsets.all(SecureChatSpace.md), child: child));
}

class SecureChatTextField extends StatelessWidget {
  const SecureChatTextField(
      {required this.label, super.key, this.controller, this.enabled = true});
  final String label;
  final TextEditingController? controller;
  final bool enabled;
  @override
  Widget build(BuildContext context) => TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(labelText: label));
}

Future<T?> showSecureChatDialog<T>(BuildContext context,
        {required Widget child}) =>
    showDialog<T>(
        context: context, builder: (_) => AlertDialog(content: child));
Future<T?> showSecureChatBottomSheet<T>(BuildContext context,
        {required Widget child}) =>
    showModalBottomSheet<T>(
        context: context,
        builder: (_) => SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(SecureChatSpace.md),
                child: child)));

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});
  @override
  Widget build(BuildContext context) => Center(
      child: Semantics(label: 'Loading', child: CircularProgressIndicator()));
}

class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(message, textAlign: TextAlign.center));
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.title, required this.message, super.key});
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: SecureChatSpace.sm),
        Text(message, textAlign: TextAlign.center)
      ]));
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
          'Not implemented'
        ),
      SecurityStatus.needsAttention => (
          SecureChatColors.warning,
          'Needs attention'
        ),
      SecurityStatus.established => (SecureChatColors.primary, 'Established')
    };
    return Semantics(
        label: value.$2,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.circle, size: 12, color: value.$1),
          const SizedBox(width: SecureChatSpace.sm),
          Text(value.$2)
        ]));
  }
}
