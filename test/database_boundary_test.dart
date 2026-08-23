import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/data/database/database.dart';

void main() {
  test(
      'pagination contract uses a bounded default page size and explicit cursor',
      () {
    const PageRequest firstPage = PageRequest();
    expect(firstPage.limit, 50);
    expect(firstPage.cursor, isNull);
  });
}
