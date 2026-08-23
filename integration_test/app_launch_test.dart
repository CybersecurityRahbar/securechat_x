import 'package:integration_test/integration_test.dart';
import 'package:securechat_x/app/securechat_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('foundation shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SecureChatApp());
    expect(find.text('SecureChat X'), findsOneWidget);
  });
}
