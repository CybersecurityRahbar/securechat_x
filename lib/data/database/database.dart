/// Platform-independent database boundary used by repositories.
///
/// Feature code must depend on this contract rather than on sqflite directly.
abstract interface class Database {
  Future<T> transaction<T>(Future<T> Function(DatabaseTransaction tx) action);

  Future<void> migrate();

  Future<List<Map<String, Object?>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
  });

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
}

/// The operations exposed while a repository is inside a database transaction.
///
/// Implementations must bind this object to the transaction executor so all
/// operations performed through it commit or roll back together.
abstract interface class DatabaseTransaction {
  Future<List<Map<String, Object?>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
  });

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
}

/// Bounded cursor pagination contract for repository implementations.
final class PageRequest {
  PageRequest({this.limit = 50, this.cursor}) : assert(limit > 0 && limit <= 200);

  final int limit;
  final String? cursor;
}

final class Page<T> {
  const Page({required this.items, this.nextCursor});

  final List<T> items;
  final String? nextCursor;
}
