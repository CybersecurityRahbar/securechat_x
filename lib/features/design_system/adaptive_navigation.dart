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

  static const int _compactNavigationLimit = 5;

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget child;
  final String title;
  final List<Widget> actions;

  int _safeIndex() => selectedIndex.clamp(0, destinations.length - 1).toInt();

  List<NavigationDestination> _compactDestinations() {
    if (destinations.length <= _compactNavigationLimit) {
      return destinations;
    }

    final List<NavigationDestination> visible = destinations
        .take(_compactNavigationLimit - 1)
        .toList(growable: true);
    visible.add(
      const NavigationDestination(
        icon: Icon(Icons.more_horiz_rounded),
        label: 'More',
      ),
    );
    return visible;
  }

  Future<void> _showMore(BuildContext context) async {
    final int selected = _safeIndex();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: destinations.length,
          padding: const EdgeInsets.fromLTRB(
            SecureChatSpace.md,
            SecureChatSpace.sm,
            SecureChatSpace.md,
            SecureChatSpace.md,
          ),
          separatorBuilder: (_, int index) =>
              const SizedBox(height: SecureChatSpace.xs),
          itemBuilder: (_, int index) {
            final NavigationDestination destination = destinations[index];
            return ListTile(
              selected: index == selected,
              leading: index == selected
                  ? (destination.selectedIcon ?? destination.icon)
                  : destination.icon,
              title: Text(destination.label),
              onTap: () {
                Navigator.of(sheetContext).pop();
                if (index != selected) {
                  onDestinationSelected(index);
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
        body: child,
      );
    }

    final bool expanded = SecureChatBreakpoints.isExpanded(context);
    final int safeIndex = _safeIndex();

    if (!expanded) {
      final List<NavigationDestination> compactDestinations =
          _compactDestinations();
      final bool hasMore = destinations.length > _compactNavigationLimit;
      final int visibleIndex =
          hasMore && safeIndex >= _compactNavigationLimit - 1
          ? _compactNavigationLimit - 1
          : safeIndex;

      return Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: visibleIndex,
          onDestinationSelected: (int index) {
            if (hasMore && index == _compactNavigationLimit - 1) {
              _showMore(context);
              return;
            }
            onDestinationSelected(index);
          },
          destinations: compactDestinations,
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
