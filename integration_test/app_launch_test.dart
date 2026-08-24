import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:securechat_x/app/app_dependencies.dart';
import 'package:securechat_x/app/securechat_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('foundation shell renders and opens Chats',
      (WidgetTester tester) async {
    final AppDependencies dependencies = AppDependencies.foundation();
    await dependencies.database.migrate();

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: SecureChatApp(lifecycle: dependencies.lifecycle),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SecureChat X'), findsOneWidget);
    expect(find.text('Command Center'), findsWidgets);

    await tester.tap(find.text('Chats').last);
    await tester.pumpAndSettle();

    expect(find.text('Conversation workspace foundation'), findsOneWidget);
    dependencies.dispose();
  });
}
