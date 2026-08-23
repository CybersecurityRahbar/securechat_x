import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/services/background/lifecycle_service.dart';

void main() {
  test('records lifecycle transitions and notifies only on change', () {
    final LifecycleService service = LifecycleService();
    var notifications = 0;
    service.addListener(() => notifications++);
    service.update(AppLifecycleState.paused);
    service.update(AppLifecycleState.paused);
    expect(service.state, AppLifecycleState.paused);
    expect(notifications, 1);
    service.dispose();
  });
}
