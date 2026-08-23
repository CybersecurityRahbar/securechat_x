import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/app_dependencies.dart';
import 'package:securechat_x/app/securechat_app.dart';

void main() {
  testWidgets(
    'application shell starts and navigates to foundational destinations',
    (WidgetTester tester) async {
      final AppDependencies dependencies = AppDependencies.foundation();
      await tester.pumpWidget(SecureChatApp(lifecycle: dependencies.lifecycle));
      await tester.pumpAndSettle();
      expect(find.text('Command Center'), findsOneWidget);

      await tester.tap(find.text('Chats'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Messaging is not implemented. No conversations or message content are available yet.',
        ),
        findsOneWidget,
      );

      dependencies.dispose();
    },
  );
}
