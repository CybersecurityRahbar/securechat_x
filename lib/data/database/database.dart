/// A database implementation and migration runner will be selected in Phase 3.
abstract interface class Database {
  Future<T> transaction<T>(Future<T> Function() action);
  Future<void> migrate();
}

final class PageRequest {
  const PageRequest({this.limit = 50, this.cursor});
  final int limit;
  final String? cursor;
}

final class Page<T> {
  const Page({required this.items, this.nextCursor});
  final List<T> items;
  final String? nextCursor;
}
