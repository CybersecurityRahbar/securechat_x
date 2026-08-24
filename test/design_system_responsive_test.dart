import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/features/design_system/adaptive_navigation.dart';

void main() {
  const List<NavigationDestination> destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Chats'),
  ];

  const List<NavigationDestination> sevenDestinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Chats'),
    NavigationDestination(icon: Icon(Icons.people_outline), label: 'Contacts'),
    NavigationDestination(icon: Icon(Icons.call_outlined), label: 'Calls'),
    NavigationDestination(
      icon: Icon(Icons.devices_other_outlined),
      label: 'Devices',
    ),
    NavigationDestination(
      icon: Icon(Icons.security_outlined),
      label: 'Security Center',
    ),
    NavigationDestination(icon: Icon(Icons.tune_outlined), label: 'Settings'),
  ];

  Future<void> pumpAtWidth(
    WidgetTester tester,
    double width, {
    List<NavigationDestination> items = destinations,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 900)),
          child: SecureChatAdaptiveNavigation(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            destinations: items,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('compact navigation uses NavigationBar',
      (WidgetTester tester) async {
    await pumpAtWidth(tester, 390);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('compact navigation collapses excess destinations into More',
      (WidgetTester tester) async {
    await pumpAtWidth(tester, 390, items: sevenDestinations);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
    expect(find.text('Devices'), findsNothing);
    expect(find.text('Security Center'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(find.text('Devices'), findsOneWidget);

    final Finder sheetScrollable = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.text('Security Center'),
      200,
      scrollable: sheetScrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Security Center'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Settings'),
      200,
      scrollable: sheetScrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('expanded navigation uses NavigationRail',
      (WidgetTester tester) async {
    await pumpAtWidth(tester, 1280, items: sevenDestinations);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('Security Center'), findsOneWidget);
  });
}
