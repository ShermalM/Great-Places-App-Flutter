import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (database, currentVersion) {
        return database.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert({String table, Map<String, Object> data}) async {
    final database = await DBHelper.database();
    await database.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final database = await DBHelper.database();
    return database.query(table);
  }
}
