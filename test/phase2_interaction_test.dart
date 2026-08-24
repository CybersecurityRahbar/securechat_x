import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/features/design_system/messaging_components.dart';
import 'package:securechat_x/features/design_system/motion_accessibility.dart';
import 'package:securechat_x/features/messaging/conversation_screen.dart';

void main() {
  testWidgets('conversation preview remains usable at compact phone width',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: const ConversationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SecureChatComposer), findsOneWidget);
    expect(find.text('Conversation preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('composer switches to compact layout without overflow',
      (WidgetTester tester) async {
    String? sent;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: MaterialApp(
          home: Scaffold(
            body: SecureChatComposer(
              onSend: (String value) => sent = value,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Preview message');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();

    expect(sent, 'Preview message');
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced-motion setting removes animation duration',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(
          disableAnimations: true,
          size: Size(390, 844),
        ),
        child: MaterialApp(
          home: SizedBox.shrink(),
        ),
      ),
    );

    final BuildContext context = tester.element(find.byType(SizedBox));
    expect(
      SecureChatMotionPreferences.duration(context, const Duration(seconds: 1)),
      Duration.zero,
    );
  });
}
