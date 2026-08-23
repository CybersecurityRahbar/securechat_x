import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/securechat_app.dart';

void main() {
  testWidgets('foundation shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SecureChatApp());
    expect(find.text('SecureChat X'), findsOneWidget);
  });
}
