import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/features/contacts/contacts_screen.dart';
import 'package:securechat_x/features/design_system/design_tokens.dart';
import 'package:securechat_x/features/devices/devices_screen.dart';
import 'package:securechat_x/features/messaging/chats_screen.dart';
import 'package:securechat_x/features/messaging/conversation_screen.dart';
import 'package:securechat_x/features/security/security_center_screen.dart';
import 'package:securechat_x/features/settings/settings_screen.dart';

void main() {
  const Size phoneSize = Size(390, 844);

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = phoneSize;
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(theme: secureChatTheme(), home: screen),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('chats shell renders on compact phone', (tester) async {
    await pumpScreen(tester, const ChatsScreen());
    expect(find.text('Chats'), findsOneWidget);
  });

  testWidgets('conversation shell renders on compact phone', (tester) async {
    await pumpScreen(tester, const ConversationScreen());
    expect(find.text('Conversation preview'), findsOneWidget);
    expect(find.text('Write a message'), findsOneWidget);
  });

  testWidgets('contacts shell renders on compact phone', (tester) async {
    await pumpScreen(tester, const ContactsScreen());
    expect(find.text('Contacts'), findsOneWidget);
  });

  testWidgets('devices shell renders on compact phone', (tester) async {
    await pumpScreen(tester, const DevicesScreen());
    expect(find.text('Devices'), findsOneWidget);
  });

  testWidgets('security center shell renders on compact phone', (tester) async {
    await pumpScreen(tester, const SecurityCenterScreen());
    expect(find.text('Security Center'), findsOneWidget);
  });

  testWidgets('settings shell renders on compact phone', (tester) async {
    await pumpScreen(tester, const SettingsScreen());
    expect(find.text('Settings'), findsOneWidget);
  });
}
