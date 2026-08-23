import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/securechat_app.dart';

void main() {
  testWidgets('application shell starts and navigates to foundational destinations', (WidgetTester tester) async {
    await tester.pumpWidget(const SecureChatApp());
    await tester.pumpAndSettle();
    expect(find.text('Command Center'), findsOneWidget);
    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    expect(find.text('Messaging is not implemented. No conversations or message content are available yet.'), findsOneWidget);
  });
}
