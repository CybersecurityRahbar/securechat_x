import 'package:flutter/material.dart';

import 'design_tokens.dart';
import 'responsive.dart';

class SecureChatAdaptiveNavigation extends StatelessWidget {
  const SecureChatAdaptiveNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.child,
    super.key,
    this.title = 'SecureChat X',
    this.actions = const <Widget>[],
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget child;
  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
        body: child,
      );
    }

    final bool expanded = SecureChatBreakpoints.isExpanded(context);
    final int safeIndex = selectedIndex.clamp(0, destinations.length - 1).toInt();

    if (!expanded) {
      return Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: safeIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: safeIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.only(top: SecureChatSpace.sm),
                child: Semantics(
                  label: title,
                  child: Text(
                    'SCX',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              destinations: destinations
                  .map(
                    (NavigationDestination item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.selectedIcon ?? item.icon,
                      label: Text(item.label),
                    ),
                  )
                  .toList(growable: false),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        const SizedBox(width: SecureChatSpace.lg),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        ...actions,
                        const SizedBox(width: SecureChatSpace.md),
                      ],
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
