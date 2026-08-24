import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/app_dependencies.dart';
import 'package:securechat_x/app/securechat_app.dart';

Future<void> pumpShell(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final AppDependencies dependencies = AppDependencies.foundation();
  addTearDown(dependencies.dispose);

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(390, 844)),
      child: SecureChatApp(lifecycle: dependencies.lifecycle),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'application shell starts and opens chats at compact width',
    (WidgetTester tester) async {
      await pumpShell(tester);

      expect(find.byKey(const Key('foundation-screen-title')), findsOneWidget);
      expect(find.text('Command Center'), findsWidgets);

      await tester.tap(find.text('Chats').last);
      await tester.pumpAndSettle();
      expect(find.text('Messaging engine not implemented'), findsOneWidget);
      expect(find.text('Conversation workspace foundation'), findsOneWidget);
      expect(find.text('Conversation UI preview'), findsOneWidget);
    },
  );

  testWidgets('compact More menu exposes devices', (WidgetTester tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    final Finder deviceMenuItem = find.widgetWithText(ListTile, 'Devices');
    expect(deviceMenuItem, findsOneWidget);
    await tester.tap(deviceMenuItem);
    await tester.pumpAndSettle();
    expect(find.text('Devices'), findsWidgets);
    expect(find.text('Current device'), findsOneWidget);
  });

  testWidgets('command palette navigates to security center',
      (WidgetTester tester) async {
    await pumpShell(tester);

    await tester.tap(find.byTooltip('Global command palette'));
    await tester.pumpAndSettle();
    expect(find.text('Command Center search'), findsOneWidget);
    expect(find.text('Security Center'), findsOneWidget);

    await tester.tap(find.text('Security Center').last);
    await tester.pumpAndSettle();
    expect(find.text('Security Center'), findsWidgets);
    expect(find.text('Security events'), findsOneWidget);
  });
}
