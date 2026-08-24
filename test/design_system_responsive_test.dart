import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/features/design_system/adaptive_navigation.dart';

void main() {
  const List<NavigationDestination> destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Chats'),
  ];

  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 900)),
          child: SecureChatAdaptiveNavigation(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            destinations: destinations,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('compact navigation uses NavigationBar', (WidgetTester tester) async {
    await pumpAtWidth(tester, 390);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('expanded navigation uses NavigationRail', (WidgetTester tester) async {
    await pumpAtWidth(tester, 1280);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
