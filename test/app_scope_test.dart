import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/app_scope.dart';
import 'package:securechat_x/app/environment.dart';

void main() {
  testWidgets('dependency scope exposes the resolved environment to the application tree', (WidgetTester tester) async {
    const AppEnvironment environment = AppEnvironment(kind: Environment.development, protocolVersion: 1);
    late AppEnvironment resolved;
    await tester.pumpWidget(AppScope(
      environment: environment,
      child: Builder(builder: (BuildContext context) { resolved = AppScope.of(context).environment; return const SizedBox(); }),
    ));
    expect(resolved, same(environment));
  });
}
