import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/app_dependencies.dart';
import 'package:securechat_x/app/app_scope.dart';
import 'package:securechat_x/app/environment.dart';
import 'package:securechat_x/core/errors/diagnostics.dart';

void main() {
  testWidgets(
    'dependency scope exposes environment and foundation dependencies',
    (WidgetTester tester) async {
      const AppEnvironment environment = AppEnvironment(
        kind: Environment.development,
        protocolVersion: 1,
      );
      final MemoryDiagnosticsReporter diagnostics = MemoryDiagnosticsReporter();
      final AppDependencies dependencies = AppDependencies.foundation();
      late AppScope resolvedScope;

      await tester.pumpWidget(
        AppScope(
          environment: environment,
          dependencies: dependencies,
          diagnostics: diagnostics,
          child: Builder(
            builder: (BuildContext context) {
              resolvedScope = AppScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedScope.environment, same(environment));
      expect(resolvedScope.dependencies, same(dependencies));
      expect(resolvedScope.diagnostics, same(diagnostics));

      diagnostics.dispose();
      dependencies.dispose();
    },
  );
}
