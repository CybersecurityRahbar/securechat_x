import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:securechat_x/app/app_dependencies.dart';
import 'package:securechat_x/app/securechat_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('foundation shell renders', (WidgetTester tester) async {
    final AppDependencies dependencies = AppDependencies.foundation();
    await tester.pumpWidget(SecureChatApp(lifecycle: dependencies.lifecycle));
    await tester.pumpAndSettle();
    expect(find.text('SecureChat X'), findsOneWidget);
    dependencies.dispose();
  });
}
